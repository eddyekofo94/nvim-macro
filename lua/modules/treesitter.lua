local ft_list = require('utils.static').langs:list('ft')

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
    ft = ft_list,
    config = function()
      require('configs.nvim-treesitter')
    end,
    dependencies = {
      'nvim-treesitter-textobjects',
      'nvim-ts-context-commentstring',
      'nvim-treesitter-endwise',
    }
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
    ft = ft_list,
    keys = '<Leader><Leader>',
    dependencies = 'nvim-treesitter',
    config = function()
      require('configs.ts-node-action')
    end,
  },

  {
    'Eandrju/cellular-automaton.nvim',
    ft = ft_list,
    cmd = 'CellularAutomaton',
    dependencies = 'nvim-treesitter',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    ft = ft_list,
    dependencies = 'nvim-treesitter',
  },
}
