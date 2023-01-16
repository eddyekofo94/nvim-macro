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
      'base',
      'misc',
      'treesitter',
    },
  })
else
  manage_plugins({
    config = {
      display = {
        open_cmd = '20new \\[packer\\]',
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
      'base',
      'completion',
      'debug',
      'lsp',
      'markup',
      'misc',
      'tools',
      'treesitter',
      'ui',
    }
  })
end
