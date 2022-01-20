local get = require('utils/get')
local langs = require('utils/langs')

return {
  'neovim/nvim-lspconfig',
  ft = get.ft_list(langs),
  requires = get.spec('cmp-nvim-lsp'),
  after = 'cmp-nvim-lsp'
}
