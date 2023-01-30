local configs = require('modules.debug.configs')

return {
  {
    'mfussenegger/nvim-dap',
    keys = { '<F5>', '<F8>', '<F9>', '<F21>', '<F45>' },
    dependencies = { 'nvim-dap-ui', 'mason-nvim-dap.nvim' },
    config = configs['nvim-dap'],
  },

  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    dependencies = { 'nvim-dap', 'nvim-web-devicons' },
    config = configs['nvim-dap-ui'],
  },

  {
    'jayp0521/mason-nvim-dap.nvim',
    lazy = true,
    dependencies = { 'nvim-dap', 'mason.nvim' },
    config = configs['mason-nvim-dap.nvim'],
  },
}