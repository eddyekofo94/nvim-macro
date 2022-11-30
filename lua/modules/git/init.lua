local M = {}
local configs = require('modules.git.configs')

M['vim-fugitive'] = {
  'tpope/vim-fugitive',
  cmd = { 'Git', 'G' },
}

M['gitsigns.nvim'] = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  requires = 'plenary.nvim',
  config = configs['gitsigns.nvim'],
}

return M
