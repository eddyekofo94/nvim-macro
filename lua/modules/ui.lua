local configs = require('modules.ui.configs')

return {
  {
    'romgrk/barbar.nvim',
    event = 'VeryLazy',
    requries = 'nvim-web-devicons',
    config = configs['barbar.nvim'],
  },

  {
    'nvim-lualine/lualine.nvim',
    -- load lualine only when a real
    -- file is about to open
    event = { 'BufReadPre', 'BufWrite' },
    dependencies = 'nvim-web-devicons',
    config = configs['lualine.nvim'],
  },

  {
    'goolord/alpha-nvim',
    cond = function()
      return vim.fn.argc() == 0 and
      vim.o.lines >= 36 and vim.o.columns >= 80
    end,
    dependencies = 'nvim-web-devicons',
    config = configs['alpha-nvim'],
  },

  {
    'SmiteshP/nvim-navic',
    dependencies = 'nvim-web-devicons',
    event = 'BufReadPost',
    config = configs['nvim-navic'],
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufRead', 'BufWrite' },
    config = configs['indent-blankline.nvim'],
  },

  {
    'echasnovski/mini.indentscope',
    event = { 'BufRead', 'BufWrite' },
    config = configs['mini.indentscope'],
  },

  {
    'folke/twilight.nvim',
    keys = { '<Leader>;' },
    cmd = { 'Twilight', 'TwilightEnable' },
    config = configs['twilight.nvim'],
  },

  {
    'junegunn/limelight.vim',
    cmd = 'Limelight',
    config = configs['limelight.vim'],
  },
}
