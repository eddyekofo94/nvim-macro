local cache = {}


---Get string representation of sign with highlight
---@param hl string name of the highlight group
---@param sym string sign symbol
---@return string sign string representation of the sign with highlight
local function mk_hl(hl, sym)
  return table.concat({ '%#', hl, '#', sym, '%*' })
end


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
function GetSign(bufnum, lnum, prefixes, cachekey)
  local cur_signs = vim.fn.sign_getplaced(bufnum, {
    group = '*',
    lnum = lnum
  })[1].signs

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

  if not sign_def then
    return ' '
  end

  return mk_hl(sign_def[1].texthl, sign_def[1].text)
end


---Get statuscolumn string
---@return string statuscol statuscolumn string representation
function GetStatuscol()
  local statuscol = {}

  local parts = {
    ['dapdiags'] = "%{%v:lua.GetSign(bufnr(),v:lnum,['Dap','Diagnostic'],'dapdiags')%}",
    ['align'] = '%=',
    ['num'] = '%{v:relnum?v:relnum:v:lnum}',
    ['space'] = ' ',
    ['fold'] = '%C',
    ['gitsigns'] = "%{%v:lua.GetSign(bufnr(),v:lnum,['GitSigns'],'gitsigns')%}",
  }

  local order = {
    'dapdiags',
    'space',
    'align',
    'num',
    'space',
    'gitsigns',
    'fold',
    'space',
  }

  for _, val in ipairs(order) do
    table.insert(statuscol, parts[val])
  end

  return table.concat(statuscol)
end


vim.api.nvim_create_autocmd({ 'FileType' }, {
  callback = function()
    local fts = require('utils.static').langs:list('ft')
    if vim.bo.bt ~= '' or not vim.tbl_contains(fts, vim.bo.ft) then
      vim.wo.statuscolumn = ''
      return
    end
    vim.wo.statuscolumn = '%!v:lua.GetStatuscol()'
  end,
})
