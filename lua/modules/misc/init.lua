local M = {}
local configs = require('modules.misc.configs')

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

M['fcitx.nvim'] = {
  'h-hg/fcitx.nvim',
  event = 'InsertEnter',
}

M['vim-easy-align'] = {
  'junegunn/vim-easy-align',
  keys = { 'ga' },
  config = configs['vim-easy-align'],
}

return M
