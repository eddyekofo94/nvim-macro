local lsp_servers = require('utils.static').langs:list('lsp_server')
lsp_servers = table.insert(lsp_servers, 'zk')

require('mason-lspconfig').setup({
  ensure_installed = lsp_servers,
})
