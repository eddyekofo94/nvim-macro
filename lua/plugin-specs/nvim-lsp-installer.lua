local get = require('utils.get')

return {
  'williamboman/nvim-lsp-installer',

  -- Use double border instead of rounded border (unluckily, lsp-installer has not provided a config option for this...)
  run = "sed -i -e 's/border = \"rounded\",*/border = \"double\"/' ~/.local/share/nvim/site/pack/packer/opt/nvim-lsp-installer/lua/nvim-lsp-installer/ui/display.lua",
  cmd = {
      'LspInstallInfo', 'LspInstall', 'LspUninstall', 'LspUninstallAll',
      'LspInstallLog', 'LspPrintInstalled'
  },
  requires = get.spec('nvim-lspconfig'),

  -- If cmp-nvim-lsp is installed then this
  -- plugin should be loaded after cmp-nvimlsp
  after = { 'nvim-lspconfig', 'cmp-nvim-lsp' },
  config = get.config('nvim-lsp-installer')
}
