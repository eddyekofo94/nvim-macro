-- Config for lua scripts for Neovim
return {
  Lua = {
    runtime = {
      version = 'LuaJIT'
    },
    diagnostics = {
      globals = { 'vim', 'en', 'cjk' }
    },
    workspace = {
      library = vim.api.nvim_get_runtime_file('', true)
    }
  }
}
