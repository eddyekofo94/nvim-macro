return {
  {
    'mfussenegger/nvim-dap',
    keys = { '<F5>', '<F8>', '<F9>', '<F21>', '<F45>' },
    dependencies = 'nvim-dap-ui',
    config = function()
      require('configs.nvim-dap')
    end,
  },

  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    dependencies = { 'nvim-dap', 'nvim-web-devicons' },
    config = function()
      require('configs.nvim-dap-ui')
    end,
  },
}
