---Escape a string
---@param str string
---@return string
local function str_escape(str)
  return (str:gsub('%%', '%%%%'):gsub('([%^%$%(%)%.%[%]%*%+%-%?])', '%%%1'))
end

---Get list of winbar symbols of the parent directories of given buffer
---@param buf number buffer handler
---@return winbar_symbol_t[] winbar symbols
local function get_dir_symbols(buf)
  local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
  local bufname = vim.api.nvim_buf_get_name(buf)
  local dir = require('utils.fn').proj_dir(bufname)
  if not dir then
    return {}
  end
  dir = vim.fn.fnamemodify(bufname, ':p:h'):gsub('^' .. str_escape(dir), '')
  local dir_symbols = vim.split(dir, sep)
  if #dir_symbols == 0 or #dir_symbols == 1 and dir_symbols[1] == '.' then
    return {}
  end
  return vim.tbl_map(function(dir_name)
    return {
      icon = '',
      name = dir_name,
    }
  end, dir_symbols)
end

---Get winbar symbol of given buffer
---@param buf number buffer handler
---@return winbar_symbol_t winbar symbol
local function get_file_symbol(buf)
  local fname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
  if fname == '' then
    return {
      icon = '',
      name = '',
    }
  end
  local extension = vim.fn.fnamemodify(fname, ':e')
  local devicons_ok, devicons = pcall(require, 'nvim-web-devicons')
  local icon, icon_hl  = '', ''
  if vim.bo[buf].bt == '' and devicons_ok then
    icon, icon_hl = devicons.get_icon(fname, extension)
  end
  return {
    icon = icon and icon .. ' ' or '',
    icon_hl = icon_hl,
    name = fname,
  }
end

---Get winbar symbols from buffer
---@param buf number buffer handler
---@return winbar_symbol_t[] symbols winbar symbols
local function get_symbols(buf)
  local dir_symbols = get_dir_symbols(buf)
  local file_symbol = get_file_symbol(buf)
  table.insert(dir_symbols, file_symbol)
  return dir_symbols
end

return {
  get_symbols = get_symbols,
}
