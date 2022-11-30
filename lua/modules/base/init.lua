local M = {}
local configs = require('modules.base.configs')

M['plenary.nvim'] = {
 'nvim-lua/plenary.nvim',
 module = 'plenary',
}

M['nvim-web-devicons'] = {
  'kyazdani42/nvim-web-devicons',
  module = 'nvim-web-devicons',
  config = configs['nvim-web-devicons'],
}

return M
