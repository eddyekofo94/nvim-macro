local get = require('utils/get')
local langs = require('utils/shared').langs

return {
  'williamboman/nvim-lsp-installer',

  -- Use double border instead of rounded border (unluckily, lsp-installer has not provided a config option for this...)
  run = "sed -i -e 's/border = \"rounded\",*/border = \"double\",/' ~/.local/share/nvim/site/pack/packer/opt/nvim-lsp-installer/lua/nvim-lsp-installer/ui/display.lua",
  ft = get.ft_list(langs),
  cmd = {
      'LspInstallInfo', 'LspInstall', 'LspUninstall', 'LspUninstallAll',
      'LspInstallLog', 'LspPrintInstalled'
  },
  requires = {
    get.spec('cmp-nvim-lsp'),
    get.spec('nvim-lspconfig'),
  },

  -- This option does not load `nvim-lspconfig` or `cmp-nvim-lsp` automatically
  -- when `nvim-lsp-installer` is loaded by cmd or ft, so I add `packadd`
  -- commands in config files for installer to ensure lspconfig and cmp-lsp
  -- is loaded before installer
  after = { 'nvim-lspconfig', 'cmp-nvim-lsp' },
  config = get.config('nvim-lsp-installer')
}
