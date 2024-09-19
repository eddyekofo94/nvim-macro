local lsp = require('utils.lsp')

local root_patterns = {
  'Pipfile',
  'pyproject.toml',
  'requirements.txt',
  'setup.cfg',
  'setup.py',
}

-- Use efm to attach black formatter as a language server
local efm = vim.fn.executable('black') == 1
  and lsp.start({
    cmd = { 'efm-langserver' },
    root_patterns = root_patterns,
    name = 'efm-formatter-black',
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        python = {
          {
            formatCommand = 'black --no-color -q -',
            formatStdin = true,
          },
        },
      },
    },
  })

---Disable lsp formatting capabilities if efm launched successfully
---@type fun(client: vim.lsp.Client, bufnr: integer)?
local on_attach
if efm then
  function on_attach(client)
    client.server_capabilities.documentFormattingProvider = false
  end
end

local server_configs = {
  {
    cmd = { 'pyright-langserver', '--stdio' },
    root_patterns = vim.list_extend({ 'pyrightconfig.json' }, root_patterns),
    on_attach = on_attach,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  },
  {
    cmd = { 'pylsp' },
    root_patterns = root_patterns,
    on_attach = on_attach,
  },
  {
    cmd = { 'jedi-language-server' },
    root_patterns = root_patterns,
    on_attach = on_attach,
  },
}

for _, server_config in ipairs(server_configs) do
  if lsp.start(server_config) then
    return
  end
end
