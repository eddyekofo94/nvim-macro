local null_ls = require('null-ls')
local null_ls_sources = require('null-ls.sources')

local langs = require('utils.static').langs
local source_names = {
  formatter = langs:list('formatter'),
  linter = langs:list('linter'),
  code_action_provider = langs:list('code_action_provider'),
  hover_provider = langs:list('hover_provider'),
}
local name_map = {
  formatter = 'formatting',
  linter = 'diagnostics',
  code_action_provider = 'code_actions',
  hover_provider = 'hover',
}
local sources = {}
for name_type, names in pairs(source_names) do
  for _, name in ipairs(names) do
    name = name:gsub('-', '_')
    table.insert(sources, null_ls.builtins[name_map[name_type]][name])
  end
end

local lsp_default_config = require('configs.lsp-server-configs.shared.default')

---Null-ls on-attach function
---@param client table LSP client
---@param bufnr integer buffer number
local function null_ls_on_attach(client, bufnr)
  local null_ls_supports_formatting = not vim.tbl_isempty(
    null_ls_sources.get_available(vim.bo[bufnr].ft, 'NULL_LS_FORMATTING')
  )
  local null_ls_supports_range_formatting = not vim.tbl_isempty(
    null_ls_sources.get_available(vim.bo[bufnr].ft, 'NULL_LS_RANGE_FORMATTING')
  )

  if not null_ls_supports_formatting and not null_ls_supports_range_formatting then
    return -- No formatters available for this filetype
  end

  -- Disable other LSP's formatting capabilities if null-ls supports it
  local active_clients = vim.lsp.buf_get_clients(bufnr)
  for _, active_client in ipairs(active_clients) do
    if active_client.name ~= 'null-ls' and active_client.capabilities then
      if null_ls_supports_range_formatting then
        active_client.capabilities.documentFormattingProvider = false
      end
      if null_ls_supports_range_formatting then
        active_client.capabilities.documentRangeFormattingProvider = false
      end
    end
  end
end

null_ls.setup({
  sources = sources,
  on_attach = function(client, bufnr)
    lsp_default_config.on_attach(client, bufnr)
    null_ls_on_attach(client, bufnr)
  end,
})
