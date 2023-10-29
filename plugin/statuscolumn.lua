_G.stc = {}
local utils = require('utils')
local ffi = require('ffi')

---@type table<string, table<string, vim.fn.sign_getdefined.ret.item>>
local signs_cache = {}

---Highlight groups created from merging other highlight groups
---@type table<string, string[]>
local merged_hlgroups = {}

---Record line number highlights for each line in each window
---@type table<integer, table<integer, string>>
local win_numhl = {}

---Return true if CursorLineSign highlight is to be used in current line,
---lua clone of neovim/src/nvim/drawline.c use_cursor_line_highlight()
---@return boolean
local function use_culhl()
  -- Should follow the logic of c func use_cursor_line_nr() to determine if
  -- CursorLineNr highlight is to be used in line number, but haven't found a
  -- way to get param winlinevars_T *wlv
  -- For signcolumn and foldcolumn, this should be enough
  return vim.wo.cul
      and (vim.wo.culopt:find('both') or vim.wo.culopt:find('number'))
      and vim.v.relnum == 0
    or false
end

---Get sign definition
---@param sign_name string sign name
---@param sign_group string group name of the signs
---@return vim.fn.sign_getdefined.ret.item? sign_def sign definition
local function get_sign_def(sign_name, sign_group)
  if not signs_cache[sign_group] then
    signs_cache[sign_group] = {}
  end

  local signs_group_cache = signs_cache[sign_group]
  local sign_def = signs_group_cache[sign_name]

  if not sign_def then
    sign_def = vim.fn.sign_getdefined(sign_name)[1]
    if not sign_def then
      return
    end
    sign_def.text = vim.trim(sign_def.text)
    -- Add missing culhl to sign definition
    if not sign_def.culhl then
      local texthl = sign_def.texthl
      local culhl = texthl .. 'Cul'
      if not merged_hlgroups[culhl] and vim.fn.hlexists(culhl) == 0 then
        local components = { 'CursorLineSign', texthl }
        utils.hl.set_default(0, culhl, utils.hl.merge(unpack(components)))
        merged_hlgroups[culhl] = components
      end
      sign_def.culhl = culhl
      vim.fn.sign_define(sign_def.name, sign_def)
    end
    signs_group_cache[sign_name] = sign_def
  end

  return sign_def
end

---Return the sign at current line
---@param prefixes string[] prefixes of the sign name
---@param sign_group string group name of the signs
---@return string sign string representation of the sign with highlight
function _G.stc.get_sign_str(prefixes, sign_group)
  local bufnum = vim.api.nvim_get_current_buf()
  local lnum = vim.v.lnum
  local win = vim.api.nvim_get_current_win()

  -- Clear line number highlight group cache
  if win_numhl[win] then
    win_numhl[win][lnum] = nil
  end

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
    not sign_def
    -- Don't show git delete signs in virtual line
    or vim.v.virtnum ~= 0 and sign_def.name:match('Git%w*[Dd]elete$')
  then
    return ' '
  end

  -- Record line number highlight group if the sign has 'numhl' set
  if sign_def.numhl then
    win_numhl[win] = win_numhl[win] or {}
    win_numhl[win][lnum] = sign_def.numhl
  end

  return utils.stl.hl(
    sign_def.text,
    use_culhl() and sign_def.culhl or sign_def.texthl
  )
end

---Return the line number highlight group at current line
---@return string line number highlight group
local function get_lnum_hl()
  local win = vim.api.nvim_get_current_win()
  local lnum = vim.v.lnum
  -- Not at cursorline or no highlight for number set
  if not use_culhl() or not win_numhl[win] or not win_numhl[win][lnum] then
    return ''
  end
  local numhl = win_numhl[win][lnum] -- lnum hlgroup set by sign
  local cul_numhl = numhl .. 'CulNr' -- lnum hlgroup set by cursorline
  -- Merge the above two hlgroups -- we are at the current line
  -- and there is a sign at the current line, so both hlgroups should be used
  if not merged_hlgroups[cul_numhl] and vim.fn.hlexists(cul_numhl) == 0 then
    local compoents = { 'CursorLineNr', numhl }
    utils.hl.set_default(0, cul_numhl, utils.hl.merge(unpack(compoents)))
    merged_hlgroups[cul_numhl] = compoents
  end
  return cul_numhl
end

---@return string line number string representation
function _G.stc.get_lnum_str()
  local nu = vim.wo.nu
  local rnu = vim.wo.rnu
  if not nu and not rnu or vim.v.virtnum ~= 0 then
    return ''
  end
  local hl = get_lnum_hl()
  if not nu then
    return utils.stl.hl(vim.v.relnum .. ' ', hl)
  end
  if not rnu then
    return utils.stl.hl(vim.v.lnum .. ' ', hl)
  end
  return utils.stl.hl(
    (
      vim.v.relnum ~= 0 and vim.v.relnum
      or string.format(
        '%-' .. math.max(3, #tostring(vim.api.nvim_buf_line_count(0))) .. 'd',
        vim.v.lnum
      )
    ) .. ' ',
    hl
  )
end

ffi.cdef([[
  typedef struct {} Error;
  typedef struct {} win_T;
  typedef struct {
    int start;  // line number where deepest fold starts
    int level;  // fold level, when zero other fields are N/A
    int llevel; // lowest level that starts in v:lnum
    int lines;  // number of lines from v:lnum to end of closed fold
  } foldinfo_T;
  foldinfo_T fold_info(win_T* win, int lnum);
  win_T *find_window_by_handle(int Window, Error *err);
]])

---Return the fold column at current line, without foldlevel numbers
---@return string
function _G.stc.get_foldcol_str()
  local lnum = vim.v.lnum
  local fcs = vim.opt.fillchars:get()
  local fold_is_opened = vim.fn.foldclosed(lnum) == -1
  local foldchar = (
    ffi.C.fold_info(ffi.C.find_window_by_handle(0, ffi.new('Error')), lnum).start
    ~= lnum
  )
      and fcs.foldsep
    or fold_is_opened and fcs.foldopen
    or fcs.foldclose
  return utils.stl.hl(
    foldchar,
    use_culhl() and 'CursorLineFold' or 'FoldColumn'
  )
end

-- 1. Diagnostic / Dap signs
-- 2. Line number
-- 3. Git signs
-- 4. Fold column
local stc = table.concat({
  '%{%&scl==#"no"?"":(v:virtnum?"":v:lua.stc.get_sign_str(["Dap","Diagnostic"],"dapdiags"))%} ',
  '%=%{%v:lua.stc.get_lnum_str()%}',
  '%{%&scl==#"no"?"":(v:lua.stc.get_sign_str(["GitSigns"],"gitsigns"))%}',
  '%{%&fdc==#"0"?"":(v:lua.stc.get_foldcol_str())%} ',
})

local groupid = vim.api.nvim_create_augroup('StatusColumn', {})
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufWinEnter' }, {
  group = groupid,
  desc = 'Set statuscolumn for each window.',
  callback = function(info)
    vim.opt_local.stc = info.file
        and vim.bo.bt == ''
        and not vim.b.large_file
        and stc
      or ''
  end,
})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = groupid,
  desc = 'Update merged highlight groups when colorscheme changes.',
  callback = function()
    for hl, components in pairs(merged_hlgroups) do
      utils.hl.set_default(0, hl, utils.hl.merge(unpack(components)))
    end
  end,
})
vim.api.nvim_create_autocmd('WinClosed', {
  group = groupid,
  desc = 'Clear line number highlight group cache when window is closed.',
  callback = function(info)
    win_numhl[tonumber(info.match)] = nil
  end,
})
