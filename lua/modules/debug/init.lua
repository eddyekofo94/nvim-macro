local M = {}
local configs = require('modules.debug.configs')

M['nvim-dap'] = {
  'mfussenegger/nvim-dap',
  keys = { '<F5>', '<F8>', '<F9>', '<F21>', '<F45>' },
  config = configs['nvim-dap'],
}

M['nvim-dap-ui'] = {
  'rcarriga/nvim-dap-ui',
  requires = { 'nvim-dap', 'nvim-web-devicons' },
  after = 'nvim-dap',
  config = configs['nvim-dap-ui'],
}

M['mason-nvim-dap.nvim'] = {
  'jayp0521/mason-nvim-dap.nvim',
  requires = { 'nvim-dap', 'mason.nvim' },
  after = 'nvim-dap',
  config = configs['mason-nvim-dap.nvim'],
}

return M
