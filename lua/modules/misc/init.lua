local M = {}
local configs = require('modules.misc.configs')

M['plenary.nvim'] = {
 'nvim-lua/plenary.nvim',
 module = 'plenary',
}

M['nvim-surround'] = {
  'kylechui/nvim-surround',
  event = 'ModeChanged',
  keys = { 'ys', 'ds', 'cs' },
  config = configs['nvim-surround'],
}

M['Comment.nvim'] = {
  'numToStr/Comment.nvim',
  keys = { 'gc', 'gb' },
  config = configs['Comment.nvim'],
}

M['vim-sleuth'] = {
  'tpope/vim-sleuth',
  event = 'BufReadPre',
}

M['nvim-autopairs'] = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = configs['nvim-autopairs']
}

return M
