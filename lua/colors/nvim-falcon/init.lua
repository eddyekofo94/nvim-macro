local M = {}

function M.apply()
  vim.cmd('syntax reset')
  vim.cmd('hi clear')
  package.loaded['colors.nvim-falcon.hlgroups'] = nil
  local hlgroups = require('colors.nvim-falcon.hlgroups')

  for hl_name, hl_settings in pairs(hlgroups) do
    vim.api.nvim_set_hl(0, hl_name, hl_settings)
  end

  -- set terminal colors
  package.loaded['colors.nvim-falcon.terminal'] = nil
  local termcolors = require('colors.nvim-falcon.terminal')
  for termcolor, hex in pairs(termcolors) do
    vim.g[termcolor] = hex
  end

  vim.g.colors_name = 'nvim-falcon'
end

return M
