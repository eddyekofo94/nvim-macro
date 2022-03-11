local get = require('utils.get')

return {
  'stevearc/aerial.nvim',
  ft = get.ft_list(require('utils.shared').langs),
  keys = { '<Leader>aa', '<Leader>ao' },
  cmd = { 'AerialOpen', 'AerialToggle' },
  requires = {
    get.spec('nvim-lspconfig'),
    get.spec('nvim-lsp-installer'),
    get.spec('nvim-treesitter')
  },
  config = get.config('aerial')
}
