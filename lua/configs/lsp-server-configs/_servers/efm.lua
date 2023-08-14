local utils = require('utils')
local default = require('configs.lsp-server-configs.shared.default')

---@param bufnr integer
---@return lsp.Client[]
local function get_efm_formatter_attached(bufnr)
  return vim.lsp.get_clients({
    bufnr = bufnr,
    name = 'efm',
    method = 'textDocument/formatting',
  })
end

---@type table<integer, true>
local formatter_disabled = {}

---@param client lsp.Client LSP client
---@return nil
local function disable_formatter(client)
  if client.server_capabilities.documentFormattingProvider then
    formatter_disabled[client.id] = true
    client.server_capabilities.documentFormattingProvider = false
  end
end

---@param client lsp.Client
---@return nil
local function restore_formatter(client)
  if formatter_disabled[client.id] then
    client.server_capabilities.documentFormattingProvider = true
    formatter_disabled[client.id] = nil
  end
end

local groupid = vim.api.nvim_create_augroup('EfmDisableOtherFormatters', {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = groupid,
  callback = function(info)
    local client = vim.lsp.get_client_by_id(info.data.client_id)
    if
      client
      and client.name ~= 'efm'
      and not vim.tbl_isempty(get_efm_formatter_attached(info.buf))
    then
      disable_formatter(client)
    end
  end,
})
vim.api.nvim_create_autocmd('LspDetach', {
  group = groupid,
  callback = function(info)
    local efm_formatters = get_efm_formatter_attached(info.buf)
    local efm_formatter = efm_formatters[1]
    if 1 == #efm_formatters and efm_formatter.id == info.data.client_id then
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = info.buf })) do
        restore_formatter(client)
      end
    end
  end,
})

return {
  init_options = { documentFormatting = true },
  filetypes = { 'lua', 'python', 'sh', 'fish' },
  single_file_support = false,
  root_dir = function(startpath)
    return utils.fs.proj_dir(startpath) or vim.fs.dirname(startpath)
  end,
  ---@param efm_client lsp.Client EFM LSP client
  ---@param bufnr number buffer handler
  on_attach = function(efm_client, bufnr)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
      if client.name ~= 'efm' then
        disable_formatter(client)
      end
    end
    default.on_attach(efm_client, bufnr)
  end,
  settings = {
    rootMarkers = utils.fs.root_patterns,
    languages = {
      lua = {
        {
          formatStdin = true,
          formatCanRange = true,
          formatCommand = 'stylua ${--indent-width:tabSize} ${--range-start:charStart} ${--range-end:charEnd} --color Never -',
          rootMarkers = { 'stylua.toml', '.stylua.toml' },
        },
      },
      python = {
        {
          formatCommand = 'black --no-color -q -',
          formatStdin = true,
        },
      },
      sh = {
        {
          formatCommand = 'shfmt --filename ${INPUT} -',
          formatStdin = true,
        },
      },
      fish = {
        {
          formatCommand = 'fish_indent ${INPUT}',
          formatStdin = true,
        },
      },
    },
  },
}
