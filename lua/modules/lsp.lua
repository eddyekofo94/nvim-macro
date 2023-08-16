return {
  {
    'neovim/nvim-lspconfig',
    event = { 'FileType' },
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
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    config = function()
      require('configs.glance')
    end,
  },
}
