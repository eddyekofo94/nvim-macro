local M = {}

M.lualine = require('lualine')

M.location = function()
  local cursor_loc = vim.api.nvim_win_get_cursor(0)
  return cursor_loc[1] .. ',' .. cursor_loc[2] + 1
end

M.clock = function()
  return os.date('%a %H:%M')
end

M.indent_style = function()
  -- Get softtabstop or equivalent fallback
  local sts
  if vim.bo.sts > 0 then
    sts = vim.bo.sts
  elseif vim.bo.sw > 0 then
    sts = vim.bo.sw
  else
    sts = vim.bo.ts
  end

  if vim.bo.expandtab then
    return 'Spaces: ' .. sts
  elseif vim.bo.ts == sts then
    return 'Tabs: ' .. vim.bo.tabstop
  else
    return 'Tabs: ' .. vim.bo.tabstop .. '/' .. sts
  end
end

M.opts = {
  options = {
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = true and vim.o.laststatus == 3,
    theme = vim.g.default_colorscheme
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' [+]',
          readonly = ' [-]',
          unnamed = ''
        }
      }
    },
    lualine_x = {
      M.indent_style,
      'encoding',
      {
        'fileformat',
        symbols = {
          unix = ' Unix',
          dos = ' DOS',
          mac = ' Mac'
        }
      },
      'filetype'
    },
    lualine_y = { M.location },
    lualine_z = { 'progress' }
  }
}
M.lualine.setup(M.opts)

return M
