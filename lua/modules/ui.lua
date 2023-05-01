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
    'SmiteshP/nvim-navic',
    dependencies = 'nvim-web-devicons',
    event = 'BufReadPost',
    config = function()
      require('configs.nvim-navic')
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'FileType',
    config = function()
      require('configs.fidget')
    end,
  },
}
