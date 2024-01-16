local M = {}

---@type lsp.ClientConfig
---@diagnostic disable-next-line: missing-fields
M.default_config = {}

---@class lsp_client_config_t: lsp.ClientConfig
---@field cmd? (string[]|fun(dispatchers: table):table)
---@field cmd_cwd? string
---@field cmd_env? (table)
---@field detached? boolean
---@field workspace_folders? (table)
---@field capabilities? lsp.ClientCapabilities
---@field handlers? table<string,function>
---@field settings? table
---@field commands? table
---@field init_options? table
---@field name? string
---@field get_language_id? fun(bufnr: integer, filetype: string): string
---@field offset_encoding? string
---@field on_error? fun(code: integer)
---@field before_init? function
---@field on_init? function
---@field on_exit? fun(code: integer, signal: integer, client_id: integer)
---@field on_attach? fun(client: lsp.Client, bufnr: integer)
---@field trace? 'off'|'messages'|'verbose'|nil
---@field flags? table
---@field root_dir? string

---Start and attach LSP client for the current buffer
---@param cmd string[]
---@param root_patterns string[]?
---@param config lsp_client_config_t?
---@return integer? client_id id of attached client or nil if failed
function M.start(cmd, root_patterns, config)
  if not cmd[1] or vim.fn.executable(cmd[1]) == 0 then
    return
  end

  local fs_utils = require('utils.fs')
  return vim.lsp.start(
    vim.tbl_deep_extend('keep', config or {}, M.default_config, {
      name = cmd[1],
      cmd = cmd,
      root_dir = fs_utils.proj_dir(
        vim.api.nvim_buf_get_name(0),
        vim.list_extend(root_patterns or {}, fs_utils.root_patterns)
      ),
    })
  )
end

return M
