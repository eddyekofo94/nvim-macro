require('utils.lsp').launch(0, { 'rust-analyzer' }, { 'Cargo.toml' }, {
  settings = {
    ['rust-analyzer'] = {
      imports = {
        prefix = 'self',
        granularity = { group = 'module' },
      },
      cargo = { buildScripts = { enable = true } },
      procMacro = { enable = true },
    },
  },
  capabilities = {
    experimental = {
      serverStatusNotification = true,
    },
  },
})
