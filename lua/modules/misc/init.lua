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

M['nvim-colorizer'] = {
  'norcalli/nvim-colorizer.lua',
  event = 'BufReadPre',
  cmd = { 'ColorizerAttachToBuffer', 'ColorizerToggle' },
  config = configs['nvim-colorizer'],
}

return M
