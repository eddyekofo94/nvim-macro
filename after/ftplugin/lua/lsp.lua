local lsp = require('utils.lsp')

-- Use efm to attach stylua formatter as a language server
local stylua_root_patterns = { 'stylua.toml', '.stylua.toml' }
local efm = vim.fn.executable('stylua') == 1
  and lsp.launch(0, { 'efm-langserver' }, stylua_root_patterns, {
    name = 'efm-formatter-stylua',
    init_options = {
      documentFormatting = true,
      documentRangeFormatting = true,
    },
    settings = {
      languages = {
        lua = {
          {
            formatStdin = true,
            formatCanRange = true,
            formatCommand = 'stylua ${--indent-width:tabSize} ${--range-start:charStart} ${--range-end:charEnd} --color Never -',
            rootMarkers = stylua_root_patterns,
          },
        },
      },
    },
  })

-- Luanch lua-language-server, disable its formatting capabilities
-- if efm launched successfully
lsp.launch(0, { 'lua-language-server' }, { '.luarc.json', '.luarc.jsonc' }, {
  on_attach = efm and function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end or nil,
})
