local get = require('utils.get')

return {
  'williamboman/nvim-lsp-installer',

  cmd = {
    'LspInstallInfo', 'LspInstall', 'LspUninstall', 'LspUninstallAll',
    'LspInstallLog', 'LspPrintInstalled'
  },
  requires = get.spec('nvim-lspconfig'),

  -- If cmp-nvim-lsp is installed then this
  -- plugin should be loaded after cmp-nvim-lsp
  after = 'nvim-lspconfig',
  config = get.config('nvim-lsp-installer')
}
