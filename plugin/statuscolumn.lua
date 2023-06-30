_G.statuscol = {}
local utils = require('utils')

---@class sign_def
---@field name string?
---@field icon string?
---@field text string?
---@field texthl string?
---@field linehl string?
---@field numhl string?
---@field culhl string?

---@type table<string, table<string, sign_def>>
local signs_cache = {}

---Highlight groups created from merging other highlight groups
---@type table<string, string[]>
local merged_hlgroups = {}

---Record line number highlights for each line in each window
---@type table<integer, table<integer, string>>
local win_linenr_hl = {}

---Get sign definition
---@param sign_name string sign name
---@param sign_group string group name of the signs
---@return table sign_def sign definition
local function get_sign_def(sign_name, sign_group)
  if not signs_cache[sign_group] then
    signs_cache[sign_group] = {}
  end

  local cached_signs = signs_cache[sign_group]
  local sign_def = cached_signs[sign_name]

  if not sign_def then
    sign_def = vim.fn.sign_getdefined(sign_name)
    if vim.tbl_isempty(sign_def) then
      return {}
    end
    sign_def[1].text = vim.trim(sign_def[1].text)
    if not sign_def[1].culhl then
      local texthl = sign_def[1].texthl
      local culhl = texthl .. 'Cul'
      if not merged_hlgroups[culhl] and vim.fn.hlexists(culhl) == 0 then
        local components = { 'CursorLineSign', texthl }
        local merge_hl = utils.funcs.stl.hl_merge(unpack(components))
        vim.api.nvim_set_hl(0, culhl, merge_hl)
        merged_hlgroups[culhl] = components
      end
      vim.fn.sign_define(sign_def[1].name, { culhl = culhl })
    end
    cached_signs[sign_group] = cached_signs[sign_group] or {}
    cached_signs[sign_group][sign_name] = sign_def
  end

  return sign_def
end

---Return the sign at current line
---@param prefixes string[] prefixes of the sign name
---@param sign_group string group name of the signs
---@return string sign string representation of the sign with highlight
function _G.statuscol.get_sign(prefixes, sign_group)
  local bufnum = vim.api.nvim_get_current_buf()
  local cursorline = vim.api.nvim_win_get_cursor(0)[1]
  local lnum = vim.v.lnum
  local winnr = vim.api.nvim_get_current_win()

  -- Clear line number highlight group cache
  win_linenr_hl[winnr] = win_linenr_hl[winnr] or {}
  win_linenr_hl[winnr][lnum] = nil

  local signs = vim.tbl_filter(
    function(sign)
      for _, prefix in ipairs(prefixes) do
        if vim.startswith(sign.name, prefix) then
          return true
        end
      end
      return false
    end,
    vim.fn.sign_getplaced(bufnum, {
      group = '*',
      lnum = lnum,
    })[1].signs
  )
  if vim.tbl_isempty(signs) then
    return ' '
  end

  local sign_max_priority = { priority = -1 }
  for _, sign in ipairs(signs) do
    if sign.priority >= sign_max_priority.priority then
      sign_max_priority = sign
    end
  end
  local sign_def = get_sign_def(sign_max_priority.name, sign_group)

  if
    vim.tbl_isempty(sign_def)
    or vim.v.virtnum ~= 0 -- Don't show git delete signs in virtual line
      and sign_def[1]
      and sign_def[1].name:match('Git%w*[Dd]elete$')
  then
    return ' '
  end

  -- Determine the highlight of the sign according to cursor line
  local hl = sign_def[1].texthl
  if lnum == cursorline and vim.wo.cul then
    hl = sign_def[1].culhl
  end

  -- Record line number highlight group if the sign has 'numhl' set
  if sign_def[1].numhl then
    win_linenr_hl[winnr][lnum] = sign_def[1].numhl
  end

  return utils.funcs.stl.hl(sign_def[1].text, hl, false)
end

---Return the line number highlight group at current line
---@return string line number highlight group
function _G.statuscol.get_lnum_hl()
  local winnr = vim.api.nvim_get_current_win()
  local lnum = vim.v.lnum
  local cursorline = vim.api.nvim_win_get_cursor(0)[1]
  if
    lnum ~= cursorline
    or not vim.wo.cul
    or (vim.wo.culopt ~= 'both' and not (vim.wo.culopt:find('number')))
    or not win_linenr_hl[winnr]
    or not win_linenr_hl[winnr][lnum]
  then
    return ''
  end
  local numhl = win_linenr_hl[winnr][lnum]
  local cursor_numhl = numhl .. 'CulNr'
  if
    not merged_hlgroups[cursor_numhl] and vim.fn.hlexists(cursor_numhl) == 0
  then
    local compoents = { 'CursorLineNr', numhl }
    local merged_hl = utils.funcs.stl.hl_merge(unpack(compoents))
    vim.api.nvim_set_hl(0, cursor_numhl, merged_hl)
    merged_hlgroups[cursor_numhl] = compoents
  end
  return cursor_numhl
end

local groupid = vim.api.nvim_create_augroup('StatusColumn', {})
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufWinEnter' }, {
  group = groupid,
  desc = 'Set statusline for each window.',
  callback = function(info)
    if info.file and vim.bo.bt == '' then
      -- 1. Diagnostic / Dap signs
      -- 2. Line number
      -- 3. Git signs
      -- 4. Fold column
      vim.wo.statuscolumn = table.concat({
        '%{%&scl==#"no"?"":(v:virtnum?"":v:lua.statuscol.get_sign(["Dap","Diagnostic"],"dapdiags"))%} ',
        '%=%{%"%#".v:lua.statuscol.get_lnum_hl()."#".(v:virtnum?"":(&nu?(&rnu?(v:relnum?v:relnum:printf("%-".max([3,len(line("$"))])."S",v:lnum)):v:lnum):(&rnu?v:relnum:"")))%} ',
        '%{%&scl==#"no"?"":(v:lua.statuscol.get_sign(["GitSigns"],"gitsigns"))%} ',
        '%C',
      })
    else
      vim.wo.statuscolumn = ''
    end
  end,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = groupid,
  desc = 'Update merged highlight groups when colorscheme changes.',
  callback = function()
    for hl, components in pairs(merged_hlgroups) do
      vim.api.nvim_set_hl(0, hl, utils.funcs.stl.hl_merge(unpack(components)))
    end
  end,
})
vim.api.nvim_create_autocmd('WinClosed', {
  group = groupid,
  desc = 'Clear line number highlight group cache when window is closed.',
  callback = function(info)
    win_linenr_hl[tonumber(info.match)] = nil
  end,
})
