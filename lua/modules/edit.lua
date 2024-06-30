return {
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'ds',
      'cs',
      { 'S', mode = 'x' },
      { '<C-g>s', mode = 'i' },
    },
    config = function()
      require('configs.nvim-surround')
    end,
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' } },
      { 'gb', mode = { 'n', 'x' } },
    },
    config = function()
      require('configs.Comment')
    end,
  },

  {
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require('configs.ultimate-autopair')
    end,
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'gl', mode = { 'n', 'x' } },
      { 'gL', mode = { 'n', 'x' } },
    },
    config = function()
      require('configs.vim-easy-align')
    end,
  },

  {
    'andymass/vim-matchup',
    events = { 'BufReadPre', 'StdinReadPre', 'TextChanged' },
    config = function()
      require('configs.vim-matchup')
    end,
  },
}
