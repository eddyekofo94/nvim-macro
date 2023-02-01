require('mason-lspconfig').setup({
  ensure_installed = require('utils.static').langs:list('lsp_server'),
})
