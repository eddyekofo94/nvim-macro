local get = require('utils/get')
local langs = require('utils/langs')

return {
  'williamboman/nvim-lsp-installer',
  ft = get.ft_list(langs),
  cmd = {
      'LspInstallInfo', 'LspInstall', 'LspUninstall', 'LspUninstallAll',
      'LspInstallLog', 'LspPrintInstalled'
  },
  requires = { get.spec('cmp-nvim-lsp'), get.spec('nvim-lspconfig') },
  after = { 'nvim-lspconfig', 'cmp-nvim-lsp' },
  config = get.config('nvim-lsp-installer')
}
