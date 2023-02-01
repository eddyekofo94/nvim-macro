local ft_list = require('utils.static').langs:list('ft')

return {
  {
    'neovim/nvim-lspconfig',
    ft = ft_list,
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
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim', 'nvim-lspconfig', },
    ft = ft_list,
    config = function()
      require('configs.mason-lspconfig')
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

  {
    'j-hui/fidget.nvim',
    ft = ft_list,
    dependencies = 'nvim-lspconfig',
    config = function()
      require('configs.fidget')
    end,
  },
}
