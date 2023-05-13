return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = {
      'TSInstall',
      'TSInstallSync',
      'TSInstallInfo',
      'TSUninstall',
      'TSUpdate',
      'TSUpdateSync',
      'TSBufEnable',
      'TSBufToggle',
      'TSEnable',
      'TSToggle',
      'TSModuleInfo',
      'TSEditQuery',
      'TSEditQueryUserAfter',
    },
    event = 'FileType',
    config = function()
      require('configs.nvim-treesitter')
    end,
    dependencies = {
      'nvim-treesitter-textobjects',
      'nvim-ts-context-commentstring',
      'nvim-treesitter-endwise',
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    dependencies = 'nvim-treesitter',
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    dependencies = 'nvim-treesitter',
  },

  {
    'CKolkey/ts-node-action',
    event = 'FileType',
    keys = '<Leader><Leader>',
    dependencies = 'nvim-treesitter',
    config = function()
      require('configs.ts-node-action')
    end,
  },

  {
    'Eandrju/cellular-automaton.nvim',
    event = 'FileType',
    cmd = 'CellularAutomaton',
    dependencies = 'nvim-treesitter',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    event = 'FileType',
    dependencies = 'nvim-treesitter',
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPost',
    cmd = { 'TSContextEnable', 'TSContextToggle' },
    dependencies = 'nvim-treesitter',
    config = function()
      require('configs.nvim-treesitter-context')
    end,
  },
}
