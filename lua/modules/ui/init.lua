local M = {}
local configs = require('modules.ui.configs')

M['nvim-web-devicons'] = {
  'kyazdani42/nvim-web-devicons',
  module = 'nvim-web-devicons',
  config = configs['nvim-web-devicons'],
}

M['barbar.nvim'] = {
  'romgrk/barbar.nvim',
  event = 'BufAdd',
  requries = 'nvim-web-devicons',
  config = configs['barbar.nvim'],
}

M['lualine.nvim'] = {
  'nvim-lualine/lualine.nvim',
  requires = 'nvim-web-devicons',
  config = configs['lualine.nvim'],
}

M['alpha-nvim'] = {
  'goolord/alpha-nvim',
  requires = 'nvim-web-devicons',
  config = configs['alpha-nvim'],
}

return M
