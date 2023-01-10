local manage_plugins = require('utils.packer').manage_plugins

if vim.g.vscode then
  manage_plugins({
    root = vim.fn.stdpath('data') .. '/vscode_neovim',
    config = {
      display = {
        non_interactive = true,
      },
    },
    -- true: load all plugins in the module
    -- false: don't load any plugins in the module
    -- nil: remove all plugins in the module
    modules = {
      base = true,          -- base plugins that provide services to other plugins, loaded only when required
      completion = nil,     -- plugins provide completion and snippets,
      lsp = nil,            -- lsp plugins,
      markup = nil,         -- plugins for markdown and tex,
      misc = true,          -- miscellaneous plugins for enhanced editing
      tools = nil,          -- git integration, navigation, terminal, undo, etc.
      treesitter = true,    -- treesitter support
      ui = nil,             -- pretty ui,
    },
  })
else
  manage_plugins({
    config = {
      snapshot_path = vim.fn.stdpath('config') .. '/snapshots',
      display = {
        open_fn = function()
          return require('packer.util').float({ border = 'single' })
        end,
        working_sym = '',
        error_sym = '',
        done_sym = '',
        removed_sym = '',
        moved_sym = 'ﰲ',
        keybindings = {
          toggle_info = '<Tab>'
        },
      },
    },
    modules = {
      base = true,
      completion = true,
      lsp = true,
      markup = true,
      misc = true,
      tools = true,
      treesitter = true,
      ui = true,
    }
  })
end
