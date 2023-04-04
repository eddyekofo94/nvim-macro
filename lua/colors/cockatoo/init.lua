local M = {}

function M.apply()
  vim.cmd.hi('clear')
  package.loaded['colors.cockatoo.hlgroups'] = nil
  local hlgroups = require('colors.cockatoo.hlgroups')

  for hl_name, hl_settings in pairs(hlgroups) do
    vim.api.nvim_set_hl(0, hl_name, hl_settings)
  end

  -- set terminal colors
  package.loaded['colors.cockatoo.terminal'] = nil
  local termcolors = require('colors.cockatoo.terminal')
  for termcolor, hex in pairs(termcolors) do
    vim.g[termcolor] = hex
  end

  vim.g.colors_name = 'cockatoo'
end

return M
