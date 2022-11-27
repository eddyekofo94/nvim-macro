-- Config for neovim lua scripts
return {
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
    },
    telemetry = {
      enable = false,
    },
  },
}
