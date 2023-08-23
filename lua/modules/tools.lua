return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = { 'Telescope', 'FZF' },
    keys = {
      '<Leader>.',
      '<Leader>F',
      '<Leader>f',
      '<Leader>f*',
      '<Leader>f/',
      '<Leader>f;',
      '<Leader>fD',
      '<Leader>fO',
      '<Leader>fS',
      '<Leader>fb',
      '<Leader>fc',
      '<Leader>fd',
      '<Leader>fe',
      '<Leader>ff',
      '<Leader>fg',
      '<Leader>fh',
      '<Leader>fH',
      '<Leader>fk',
      '<Leader>fm',
      '<Leader>fm',
      '<Leader>fo',
      '<Leader>fp',
      '<Leader>fq',
      '<Leader>fq:',
      '<Leader>fq?',
      '<Leader>fr',
      '<Leader>fs',
      '<Leader>fu',
    },
    dependencies = {
      'plenary.nvim',
      'telescope-fzf-native.nvim',
      'telescope-undo.nvim',
    },
    config = function()
      require('configs.telescope')
    end,
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
    'debugloop/telescope-undo.nvim',
    lazy = true,
    dependencies = { 'plenary.nvim', 'telescope.nvim' },
  },

  {
    'willothy/flatten.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.flatten')
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    -- stylua: ignore start
    keys = {
      { '<M-i>',        mode = { 'n', 't' } },
      { '<C-\\>v',      mode = { 'n', 't' } },
      { '<C-\\>s',      mode = { 'n', 't' } },
      { '<C-\\>t',      mode = { 'n', 't' } },
      { '<C-\\>f',      mode = { 'n', 't' } },
      { '<C-\\>g',      mode = { 'n', 't' } },
      { '<C-\\><C-v>',  mode = { 'n', 't' } },
      { '<C-\\><C-s>',  mode = { 'n', 't' } },
      { '<C-\\><C-t>',  mode = { 'n', 't' } },
      { '<C-\\><C-f>',  mode = { 'n', 't' } },
      { '<C-\\><C-g>',  mode = { 'n', 't' } },
      { '<C-\\><C-\\>', mode = { 'n', 't' } },
    },
    -- stylua: ignore end
    cmd = {
      'Lazygit',
      'TermExec',
      'ToggleTerm',
      'ToggleTermSetName',
      'ToggleTermToggleAll',
      'ToggleTermSendCurrentLine',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = function()
      require('configs.toggleterm')
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = 'plenary.nvim',
    config = function()
      require('configs.gitsigns')
    end,
  },

  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Gcd',
      'Gclog',
      'Gdiffsplit',
      'Gdrop',
      'Gedit',
      'Ggrep',
      'Git',
      'Glcd',
      'Glgrep',
      'Gllog',
      'Gpedit',
      'Gread',
      'Gsplit',
      'Gtabedit',
      'Gvdiffsplit',
      'Gvsplit',
      'Gwq',
      'Gwrite',
    },
    event = { 'BufWritePost', 'BufReadPre' },
    config = function()
      require('configs.vim-fugitive')
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.git-conflict')
    end,
  },

  {
    'kevinhwang91/rnvimr',
    config = function()
      require('configs.rnvimr')
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufNew', 'BufRead' },
    config = function()
      require('configs.nvim-colorizer')
    end,
  },
}
