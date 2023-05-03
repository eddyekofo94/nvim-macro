vim.env.ZK_NOTEBOOK_DIR = os.getenv('HOME') .. '/School/Notes'
local zk = require('zk')
local lsp_server_config = require('configs.lsp-server-configs.shared.default')

zk.setup({
  picker = 'telescope',
  lsp = {
    config = {
      cmd = { 'zk', 'lsp' },
      name = 'zk',
      on_attach = lsp_server_config.on_attach,
    },
  },
})
