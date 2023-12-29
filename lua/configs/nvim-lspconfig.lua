---Customize LspInfo floating window
require('lspconfig.ui.windows').default_options.border = vim.g.modern_ui
    and 'solid'
  or 'single'

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Reload LspInfo floating window on VimResized.',
  group = vim.api.nvim_create_augroup('LspInfoResize', {}),
  callback = function()
    if vim.bo.ft == 'lspinfo' then
      vim.api.nvim_win_close(0, true)
      vim.cmd.LspInfo()
    end
  end,
})

local manager = require('lspconfig.manager')
---@diagnostic disable-next-line: invisible
local _start_new_client = manager._start_new_client
---Override lspconfig manager `_start_new_client()` method to silently
---quit if language server is not installed
---@param _ integer bufnr, ignored
---@param new_config lspconfig.Config
---@vararg any
---@diagnostic disable-next-line: duplicate-set-field, invisible
function manager:_start_new_client(_, new_config, ...)
  local bin = new_config and new_config.cmd and new_config.cmd[1]
  if bin and vim.fn.executable(bin) == 0 then
    return
  end
  return _start_new_client(self, _, new_config, ...)
end

---Setup all LSP servers
local lspconfig = require('lspconfig')
local ft_servers = require('utils.static').langs:map('lsp_server')
local server_configs = require('configs.lsp-server-configs')
---@param ft string file type
---@return boolean? is_setup
local function setup_ft(ft)
  local servers = ft_servers[ft]
  if not servers then
    return false
  end
  if type(servers) ~= 'table' then
    servers = { servers }
  end
  for _, server in ipairs(servers) do
    lspconfig[server].setup(server_configs[server])
  end
  ft_servers[ft] = nil
  vim.api.nvim_exec_autocmds('FileType', { pattern = ft })
  return true
end
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  setup_ft(vim.bo[buf].ft)
end
local groupid = vim.api.nvim_create_augroup('LspServerLazySetup', {})
for ft, _ in pairs(ft_servers) do
  vim.api.nvim_create_autocmd('FileType', {
    once = true,
    pattern = ft,
    group = groupid,
    callback = function()
      return setup_ft(ft)
    end,
  })
end
