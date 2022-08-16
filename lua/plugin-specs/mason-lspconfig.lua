return {
  'williamboman/mason-lspconfig.nvim',
  requires = {
    require('plugin-specs.mason'),
    require('plugin-specs.nvim-lspconfig')
  },
  config = function() require('plugin-configs.mason-lspconfig') end
}
