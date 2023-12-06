return {
  {
    'neovim/nvim-lspconfig',
    event = { 'FileType' },
    cmd = { 'LspInfo', 'LspStart' },
    config = function()
      vim.schedule(function()
        require('configs.nvim-lspconfig')
      end)
    end,
  },

  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    dependencies = 'neovim/nvim-lspconfig',
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
