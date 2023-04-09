local default_config = require('configs.lsp-server-configs.shared.default')

local settings = {
  pylsp = {
    plugins = {
      pycodestyle = {
        ignore = { 'W503', 'E203' },
      },
    },
  },
}

return vim.tbl_deep_extend('force', default_config, {
  settings = settings,
})
