local get = require('utils/get')
local langs = require('utils/langs')

return {
  get.spec('cmp-nvim-lsp'),
  {
    'neovim/nvim-lspconfig',
    ft = get.ft_list(langs),
    after = 'cmp-nvim-lsp'
  }
}
