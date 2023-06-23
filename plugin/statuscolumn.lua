_G.statuscol = {}
local cache = {}
local utils = require('utils')

---Get sign definition
---@param sign_name string sign name
---@param cachekey string key of the cache
---@return nil|table sign_def sign definition
local function get_sign_def(sign_name, cachekey)
  if not cache[cachekey] then
    cache[cachekey] = {}
  end

  local cached_signs = cache[cachekey]
  local sign_def = cached_signs[sign_name]

  if not sign_def then
    sign_def = vim.fn.sign_getdefined(sign_name)
    if vim.tbl_isempty(sign_def) then
      return nil
    end
    sign_def[1].text = vim.trim(sign_def[1].text)
    cached_signs[sign_name] = sign_def
  end

  return sign_def
end

---Return the sign at current line
---@param bufnum integer current buffer number
---@param lnum integer current line number
---@param prefixes string[] prefixes of the sign name
---@param cachekey string key of the cache
---@return string sign string representation of the sign with highlight
function _G.statuscol.get_sign(bufnum, lnum, prefixes, cachekey)
  local cur_signs =
    vim.fn.sign_getplaced(bufnum, { group = '*', lnum = lnum })[1].signs

  local diag_signs = {}
  for _, sign in ipairs(cur_signs) do
    for _, prefix in ipairs(prefixes) do
      if vim.startswith(sign.name, prefix) then
        table.insert(diag_signs, sign)
        break
      end
    end
  end

  local max_priority_sign = { priority = -1 }
  for _, sign in ipairs(diag_signs) do
    if sign.priority > max_priority_sign.priority then
      max_priority_sign = sign
    end
  end

  local sign_def = get_sign_def(max_priority_sign.name, cachekey)

  if
    not sign_def
    or vim.v.virtnum ~= 0 -- Don't show git delete signs in virtual line
      and sign_def[1]
      and sign_def[1].name:match('Git%w*[Dd]elete$')
  then
    return ' '
  end

  return utils.funcs.stl.hl(sign_def[1].text, sign_def[1].texthl)
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('StatusColumn', {}),
  callback = function(tbl)
    if tbl.file and vim.uv.fs_stat(tbl.file) and vim.bo.bt == '' then
      -- 1. Diagnostic / Dap signs
      -- 2. Line number
      -- 3. Git signs
      -- 4. Fold column
      vim.wo.statuscolumn = table.concat({
        "%{%&scl=='no'?'':(v:virtnum?'':v:lua.statuscol.get_sign(bufnr(),v:lnum,['Dap','Diagnostic'],'dapdiags'))%} ",
        "%=%{%v:virtnum?'':(&nu?(&rnu?(v:relnum?v:relnum:printf('%-'.max([3,len(line('$'))]).'S',v:lnum)):v:lnum):(&rnu?v:relnum:''))%} ",
        "%{%&scl=='no'?'':(v:lua.statuscol.get_sign(bufnr(),v:lnum,['GitSigns'],'gitsigns'))%}",
        '%C ',
      })
    else
      vim.wo.statuscolumn = ''
    end
  end,
})
