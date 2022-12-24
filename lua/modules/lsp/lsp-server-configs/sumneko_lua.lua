local function config_path(app)
  return string.format('%s/.config/%s',
    os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') or '', app)
end

local function inside_nvim_runtime_paths(path)
  for _, runtime_path in ipairs(vim.api.nvim_list_runtime_paths()) do
    if vim.startswith(path, runtime_path) then
      return true
    end
  end
  return false
end

local function on_new_config(config, root_dir)
  if not root_dir then return end
  if inside_nvim_runtime_paths(root_dir) then
    config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          enable = true,
          globals = { 'vim', 'use' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    })
  elseif root_dir:match(config_path('awesome')) then
    config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
      Lua = {
        diagnostics = {
          enable = true,
          globals = {
            'awesome',
            'client',
            'screen',
            'root',
          },
        },
      },
    })
  end
end

return {
  on_new_config = on_new_config,
}
