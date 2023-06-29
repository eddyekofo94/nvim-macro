local M = {}

---Get string representation of a string with highlight
---@param str? string sign symbol
---@param hl? string name of the highlight group
---@param restore? boolean restore highlight after the sign, default true
---@return string sign string representation of the sign with highlight
function M.hl(str, hl, restore)
  restore = restore == nil and true or restore
  if restore then
    return table.concat({ '%#', hl or '', '#', str or '', '%*' })
  else
    return table.concat({ '%#', hl or '', '#', str or '' })
  end
end

---Merge highlight attributes, use values from the right most hl group
---if there are conflicts
---@vararg string highlight group names
---@return table merged highlight attributes
function M.hl_merge(...)
  local hl_attr = vim.tbl_map(function(hl_name)
    return vim.api.nvim_get_hl(0, {
      name = hl_name,
      link = false,
    })
  end, { ... })
  return vim.tbl_extend('force', unpack(hl_attr))
end

---Make a winbar string clickable
---@param str string
---@param callback string
---@return string
function M.make_clickable(str, callback)
  return string.format('%%@%s@%s%%X', callback, str)
end

return M
