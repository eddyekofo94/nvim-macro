return {
  {
    'romgrk/barbar.nvim',
    event = { 'BufReadPost', 'BufWrite' },
    dependencies = 'nvim-web-devicons',
    config = function()
      require('configs.barbar')
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    -- load lualine only when a real
    -- file is about to open
    event = { 'BufReadPost', 'BufWrite' },
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
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufRead', 'BufWrite' },
    config = function()
      require('configs.indent-blankline')
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
    'stevearc/aerial.nvim',
    keys = { '<Leader>O', '<Leader>o' },
    cmd = { 'AerialToggle', 'AerialOpen', 'AerialOpenAll' },
    config = function()
      require('configs.aerial')
    end,
  },

  { -- Requires `sdl2_mixer` and `python-pysdl2`
    'skywind3000/vim-keysound',
    cmd = 'KeysoundEnable',
    event = 'InsertEnter',
    config = function()
      require('configs.vim-keysound')
    end,
  },
}
