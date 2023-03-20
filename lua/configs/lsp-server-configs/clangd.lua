local default_config = require('configs.lsp-server-configs.shared.default')

local clangd_config = {
  on_attach = default_config.on_attach,
  capabilities = default_config.capabilities,
}

clangd_config.capabilities.offsetEncoding = { 'utf-16' }

return clangd_config
