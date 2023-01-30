local configs = require('modules/tools/configs')

return {
  {
    'williamboman/mason.nvim',
    cmd = {
      'Mason',
      'MasonUninstall',
      'MasonLog',
      'MasonInstall',
      'MasonUninstallAll',
    },
    config = configs['mason.nvim'],
  },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      '<Leader>F', '<Leader>ff', '<Leader>fo', '<Leader>f;',
      '<Leader>f*', '<Leader>fh', '<Leader>fm', '<Leader>fb',
      '<Leader>fr', '<Leader>fa', '<Leader>fe', '<Leader>fp',
      '<Leader>fs', '<Leader>fS', '<Leader>fg', '<Leader>fm',
      '<Leader>fd'
    },
    dependencies = {
      'plenary.nvim',
      'telescope-fzf-native.nvim'
    },
    config = configs['telescope.nvim'],
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- If it complains 'fzf doesn't exists, run 'make' inside
    -- the root folder of this plugin
    build = 'make',
    lazy = true,
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'mbbill/undotree',
    keys = '<Leader>u',
    cmd = { 'UndotreeToggle', 'UndotreeShow' },
    config = configs['undotree'],
  },

  {
    'voldikss/vim-floaterm',
    keys = {
      { '<C-\\>', mode = { 'n', 't' } },
      { '<M-i>', mode = { 'n', 't' } },
    },
    cmd = { 'FloatermNew', 'FloatermToggle', 'ToggleTool' },
    config = configs['vim-floaterm'],
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = 'plenary.nvim',
    config = configs['gitsigns.nvim'],
  },

  {
    'kevinhwang91/rnvimr',
    lazy = false,
    config = configs['rnvimr'],
  },

  {
    'aserowy/tmux.nvim',
    keys = { '<M-h>', '<M-j>', '<M-k>', '<M-l>' },
    config = configs['tmux.nvim'],
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufNew', 'BufRead' },
    config = configs['nvim-colorizer.lua'],
  },
}
