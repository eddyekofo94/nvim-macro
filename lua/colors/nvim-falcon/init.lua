local M = {}

local colorscheme = require('colors.nvim-falcon.colorscheme')

function M.apply()
  vim.opt.background = 'dark'
  vim.cmd('syntax reset')
  vim.cmd('hi clear')
  for hl_name, hl_settings in pairs(colorscheme) do
    vim.api.nvim_set_hl(0, hl_name, hl_settings)
  end
  -- set terminal colors
  require('colors.nvim-falcon.terminal')
  vim.g.colors_name = 'nvim_falcon'
end

return M
