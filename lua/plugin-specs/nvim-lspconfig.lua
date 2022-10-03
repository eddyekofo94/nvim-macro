return {
  'neovim/nvim-lspconfig',
  opt = true,
  ft = require('utils.static').langs:list('ft'),
  config = function() require('plugin-configs.nvim-lspconfig') end
}
