return {
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua', 'F', 'FZ', 'FZF' },
    keys = {
      '<Leader>.',
      '<Leader>,',
      '<Leader>/',
      '<Leader>F',
      '<Leader>f"',
      '<Leader>f',
      '<Leader>f*',
      '<Leader>f/',
      '<Leader>f:',
      '<Leader>fD',
      '<Leader>fE',
      '<Leader>fH',
      '<Leader>fO',
      '<Leader>fS',
      '<Leader>fa',
      '<Leader>fb',
      '<Leader>fc',
      '<Leader>fd',
      '<Leader>fe',
      '<Leader>ff',
      '<Leader>fg',
      '<Leader>fG',
      '<Leader>fh',
      '<Leader>fk',
      '<Leader>fl',
      '<Leader>fL',
      '<Leader>fm',
      '<Leader>fo',
      '<Leader>fq/',
      '<Leader>fq:',
      '<Leader>fq?',
      '<Leader>fr',
      '<Leader>fs',
    },
    config = function()
      require('configs.fzf-lua')
    end,
  },

  {
    'willothy/flatten.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.flatten')
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
