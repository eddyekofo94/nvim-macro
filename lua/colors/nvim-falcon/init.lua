local M = {}

function M.apply()
  vim.cmd('syntax reset')
  vim.cmd('hi clear')
  local utils = require('colors.nvim-falcon.utils')
  local colorscheme = utils.reload('colors.nvim-falcon.colorscheme')

  for hl_name, hl_settings in pairs(colorscheme) do
    vim.api.nvim_set_hl(0, hl_name, hl_settings)
  end

  -- set terminal colors
  local termcolors = utils.reload('colors.nvim-falcon.terminal')
  for termcolor, hex in pairs(termcolors) do
    vim.g[termcolor] = hex
  end

  vim.g.colors_name = 'nvim-falcon'
end

return M
