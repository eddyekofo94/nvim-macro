return {
  'neovim/nvim-lspconfig',
  opt = true,
  ft = require('utils.shared').langs:list('ft'),
  config = function() require('plugin-configs.nvim-lspconfig') end
}
