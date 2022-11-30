local manage_plugins = require('utils.packer').manage_plugins

if vim.g.vscode then
  local root = vim.fn.stdpath('data') .. '/vsc_nvim_pkgs'
  manage_plugins({
    root = root,
    bootstrap = {
      path = root .. '/pack/packer/opt/packer.nvim',
    },
    config = {
      package_root = root .. '/pack',
      compile_path = root .. '/lua/packer_compiled.lua',
      display = {
        non_interactive = true,
      },
    },
    -- true: load all plugins in the module
    -- false: don't load any plugins in the module
    -- nil: remove all plugins in the module
    modules = {
      base = true,          -- base plugins that provide services to other plugins, loaded only when required
      completion = false,   -- plugins provide completion and snippets,
      git = false,          -- git integration
      lsp = false,          -- lsp plugins,
      markup = false,       -- plugins for markdown and tex,
      misc = true,          -- miscellaneous plugins for enhanced editing
      tools = false,        -- navigation, terminal, undo, etc.,
      treesitter = true,    -- treesitter support
      ui = false,           -- pretty ui,
    },
  })
else
  manage_plugins({
    modules = {
      base = true,
      completion = true,
      git = true,
      lsp = true,
      markup = true,
      misc = true,
      tools = true,
      treesitter = true,
      ui = true,
    }
  })
end
