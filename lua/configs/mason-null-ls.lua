local langs = require('utils.static').langs
local client_names = {
  formatter = langs:list('formatter'),
  linter = langs:list('linter'),
  code_action_provider = langs:list('code_action_provider'),
  hover_provider = langs:list('hover_provider'),
}

local ensure_installed = {}
for _, names in pairs(client_names) do
  for _, name in ipairs(names) do
    table.insert(ensure_installed, name)
  end
end

require('mason-null-ls').setup({
  ensure_installed = ensure_installed,
})
