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
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('configs.nvim-autopairs')
    end,
  },

  {
    'h-hg/fcitx.nvim',
    event = 'InsertEnter',
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'ga', mode = { 'n', 'x' } },
      { 'gA', mode = { 'n', 'x' } },
    },
    config = function()
      require('configs.vim-easy-align')
    end,
  },
}
