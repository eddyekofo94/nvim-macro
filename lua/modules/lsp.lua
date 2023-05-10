return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'FileType' },
    cmd = { 'LspInfo', 'LspStart' },
    config = function()
      require('configs.nvim-lspconfig')
    end,
  },

  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    dependencies = 'nvim-lspconfig',
    config = function()
      require('configs.clangd_extensions')
    end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'FileType' },
    cmd = {
      'NullLsLog',
      'NullLsInfo',
      'NullLsFormatOnSaveToggle',
    },
    dependencies = { 'plenary.nvim' },
    config = function()
      require('configs.null-ls')
    end,
  },

  {
    'folke/neodev.nvim',
    ft = 'lua',
    config = function()
      require('configs.neodev')
    end,
  },
}
