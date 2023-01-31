local configs = require('modules.misc.configs')

return {
  {
    'kylechui/nvim-surround',
    keys = {
      'ys', 'ds', 'cs',
      { 'S', mode = 'x' },
      { '<C-g>s', mode = 'i' },
    },
    config = configs['nvim-surround'],
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' } },
      { 'gb', mode = { 'n', 'x' } },
    },
    config = configs['Comment.nvim'],
  },

  {
    'tpope/vim-sleuth',
    event = 'BufReadPre',
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = configs['nvim-autopairs']
  },

  {
    'h-hg/fcitx.nvim',
    event = 'InsertEnter',
  },

  {
    'junegunn/vim-easy-align',
    keys = {
      { 'ga', mode = { 'n', 'x' } }
    },
    config = configs['vim-easy-align'],
  },
}
