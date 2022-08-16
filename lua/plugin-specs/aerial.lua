return {
  'stevearc/aerial.nvim',
  requires = require('plugin-specs.nvim-treesitter'),
  config = function() require('plugin-configs.aerial') end,
  after = 'nvim-lspconfig'
}
