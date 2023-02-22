vim.env.ZK_NOTEBOOK_DIR= os.getenv('HOME') .. '/School/Notes'

require('zk').setup({
  picker = 'telescope',
  lsp = {
    config = {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/zk', 'lsp' },
      name = 'zk',
      on_attach = require('configs.lsp-server-configs.shared.default').on_attach,
    }
  }
})
