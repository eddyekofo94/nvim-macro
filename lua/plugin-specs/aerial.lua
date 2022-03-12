local get = require('utils.get')

return {
  'stevearc/aerial.nvim',
  requires = {
    get.spec('nvim-lspconfig'),
    get.spec('nvim-lsp-installer'),
    get.spec('nvim-treesitter')
  },
  after = 'nvim-lsp-installer',
  config = get.config('aerial')
}
