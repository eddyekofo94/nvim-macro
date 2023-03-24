local langs = require('utils.static').langs
local null_ls_builtin_types = {
  'formatting',
  'diagnostics',
  'code_actions',
  'hover',
}

local ensure_installed = {}
for _, type in ipairs(null_ls_builtin_types) do
  local source_names = langs:list(type)
  for _, name in ipairs(source_names) do
    table.insert(ensure_installed, name)
  end
end

require('mason-null-ls').setup({
  ensure_installed = ensure_installed,
})
