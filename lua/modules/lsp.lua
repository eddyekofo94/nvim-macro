local configs = require('modules.lsp.configs')
local ft_list = require('utils.static').langs:list('ft')

return {
  {
    'neovim/nvim-lspconfig',
    ft = ft_list,
    config = configs['nvim-lspconfig'],
  },

  {
    'p00f/clangd_extensions.nvim',
    ft = { 'c', 'cpp' },
    dependencies = 'nvim-lspconfig',
    config = configs['clangd_extensions.nvim'],
  },

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim', 'nvim-lspconfig', },
    ft = ft_list,
    config = configs['mason-lspconfig.nvim'],
  },

  {
    'stevearc/aerial.nvim',
    keys = { '<Leader>O', '<Leader>o' },
    cmd = { 'AerialToggle', 'AerialOpen', 'AerialOpenAll' },
    config = configs['aerial.nvim'],
  },

  {
    'j-hui/fidget.nvim',
    ft = ft_list,
    dependencies = 'nvim-lspconfig',
    config = configs['fidget.nvim'],
  },
}
