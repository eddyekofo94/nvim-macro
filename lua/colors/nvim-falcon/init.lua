local M = {}

local colorscheme = require('colors.nvim-falcon.colorscheme_falcon')

function M.apply()
  vim.opt.background = 'dark'
  vim.cmd('syntax reset')
  vim.cmd('hi clear')
  for hl_name, hl_settings in pairs(colorscheme) do
    if hl_settings.link then
      vim.cmd('hi link ' .. hl_name .. ' ' .. hl_settings.link)
    else
      vim.api.nvim_set_hl(0, hl_name, hl_settings)
    end
  end
  vim.g.colors_name = 'nvim_falcon'
end

return M
