return {
  {
    'mfussenegger/nvim-dap',
    cmd = {
      'DapContinue',
      'DapLoadLaunchJSON',
      'DapRestartFrame',
      'DapSetLogLevel',
      'DapShowLog',
      'DapToggleBreakPoint',
    },
    keys = { '<F5>', '<F8>', '<F9>', '<F21>', '<F45>' },
    dependencies = 'nvim-dap-ui',
    config = function()
      require('configs.nvim-dap')
    end,
  },

  {
    'jbyuki/one-small-step-for-vimkind',
    cmd = 'DapOSVLaunchServer',
    dependencies = 'nvim-dap',
    config = function()
      require('configs.one-small-step-for-vimkind')
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
