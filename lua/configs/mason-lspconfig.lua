local lsp_servers = require('utils.static').langs:list('lsp_server')

require('mason-lspconfig').setup({
  ensure_installed = lsp_servers,
})
