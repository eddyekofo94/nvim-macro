return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })()
    end,
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
      vim.schedule(function()
        require('configs.nvim-treesitter')
      end)
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        init = function() end,
      },
      'nvim-treesitter/nvim-treesitter-context',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'RRethy/nvim-treesitter-endwise',
    },
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    keys = { '<M-C-K>', '<M-NL>', 'g<M-NL>' },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('configs.treesj')
    end,
  },

  {
    'Eandrju/cellular-automaton.nvim',
    event = 'FileType',
    cmd = 'CellularAutomaton',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    event = 'FileType',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  {
    'RRethy/vim-illuminate',
    -- INFO: disabled for now
    -- enabled = false,
    event = 'BufReadPre',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    -- config = require "custom.configs.illuminate",
  },
}
