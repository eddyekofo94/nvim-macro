return {
  {
    'romgrk/barbar.nvim',
    event = 'VeryLazy',
    requries = 'nvim-web-devicons',
    config = function()
      require('configs.barbar')
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    -- load lualine only when a real
    -- file is about to open
    event = { 'BufReadPre', 'BufWrite' },
    dependencies = 'nvim-web-devicons',
    config = function()
      require('configs.lualine')
    end,
  },

  {
    'goolord/alpha-nvim',
    cond = function()
      return vim.fn.argc() == 0 and
      vim.o.lines >= 36 and vim.o.columns >= 80
    end,
    config = function()
      require('configs.alpha-nvim')
    end,
  },

  {
    'SmiteshP/nvim-navic',
    dependencies = 'nvim-web-devicons',
    event = 'BufReadPost',
    config = function()
      require('configs.nvim-navic')
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufRead', 'BufWrite' },
    config = function()
      require('configs.indent-blankline')
    end,
  },

  {
    'echasnovski/mini.indentscope',
    event = { 'BufRead', 'BufWrite' },
    config = function()
      require('configs.indentscope')
    end,
  },

  {
    'folke/twilight.nvim',
    keys = { '<Leader>;' },
    cmd = { 'Twilight', 'TwilightEnable' },
    config = function()
      require('configs.twilight')
    end,
  },

  {
    'junegunn/limelight.vim',
    cmd = 'Limelight',
    config = function()
      require('configs.limelight')
    end,
  },
}
