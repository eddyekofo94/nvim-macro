local configs = require('modules.misc.configs')

return {
  {
    'kylechui/nvim-surround',
    event = 'ModeChanged',
    keys = { 'ys', 'ds', 'cs' },
    config = configs['nvim-surround'],
  },

  {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gb' },
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
