local get = require('utils/get')
local langs = require('utils/langs')

return {
  get.spec('cmp-nvim-lsp'),
  get.spec('nvim-lspconfig'),
  {
    'williamboman/nvim-lsp-installer',
    ft = get.ft_list(langs),
    cmd = {
        'LspInstallInfo', 'LspInstall', 'LspUninstall', 'LspUninstallAll',
        'LspInstallLog', 'LspPrintInstalled'
    },
    after = { 'nvim-lspconfig', 'cmp-nvim-lsp' },
    config = get.config('nvim-lsp-installer')
  }
}
