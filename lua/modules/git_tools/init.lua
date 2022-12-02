local M = {}
local configs = require('modules.git_tools.configs')

M['gitsigns.nvim'] = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  requires = 'plenary.nvim',
  config = configs['gitsigns.nvim'],
}

return M
