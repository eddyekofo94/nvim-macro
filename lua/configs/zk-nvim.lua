vim.env.ZK_NOTEBOOK_DIR = os.getenv('HOME') .. '/School/Notes'
local zk = require('zk')
local lsp_server_config = require('configs.lsp-server-configs.shared.default')

local zk_config = {
  picker = 'telescope',
  lsp = {
    config = {
      cmd = { vim.fn.stdpath('data') .. '/mason/bin/zk', 'lsp' },
      name = 'zk',
      on_attach = lsp_server_config.on_attach,
    },
  },
}

-- Setup zk if installed locally
if vim.loop.fs_stat(zk_config.lsp.config.cmd[1]) then
  zk.setup(zk_config)
  return true
end

-- zk is missing, check if zk is installed globally
if vim.fn.executable('zk') == 1 then
  zk_config.lsp.config.cmd = { 'zk', 'lsp' }
  zk.setup(zk_config)
  return true
end

-- Try to install zk using mason.nvim
local mason_api_ok, mason_api = pcall(require, 'mason.api.command')
if mason_api_ok then
  mason_api.MasonInstall({ 'zk' })
  zk.setup(zk_config)
  return true
end

vim.notify('[zk] zk executable not found', vim.log.levels.WARN)
return false
