return {
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
    'j-hui/fidget.nvim',
    event = 'FileType',
    config = function()
      require('configs.fidget')
    end,
  },
}
