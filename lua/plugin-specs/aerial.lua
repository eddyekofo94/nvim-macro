return {
  'stevearc/aerial.nvim',
  ft = require('utils.static').langs:list('ft'),
  requires = require('plugin-specs.nvim-treesitter'),
  config = function() require('plugin-configs.aerial') end,
  after = 'nvim-lspconfig'
}
