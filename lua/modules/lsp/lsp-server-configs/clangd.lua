local default_config = require('modules.lsp.lsp-server-configs.default')

return vim.tbl_deep_extend('force', default_config, {
  capabilities = {
    offsetEncoding = { 'utf-8' },
  },
})
