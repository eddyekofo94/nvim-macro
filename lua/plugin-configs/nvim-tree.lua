local M = {}

vim.keymap.set('n', '<Leader>tt', function() require('nvim-tree').toggle(false, false) end, { noremap = true })
vim.keymap.set('n', '<Leader>tc', function() require('nvim-tree.actions.copy-paste').print_clipboard() end, { noremap = true })
vim.keymap.set('n', '<Leader>tq', function() require('nvim-tree.view').close() end, { noremap = true })
vim.keymap.set('n', '<Leader>tff', function() require('nvim-tree').find_file(true) end, { noremap = true })
vim.keymap.set('n', '<Leader>tft', function() require('nvim-tree').toggle(true, false) end, { noremap = true })
vim.keymap.set('n', '<Leader>to', function() require('nvim-tree').open() end, { noremap = true })
vim.keymap.set('n', '<Leader>tr', function() require('nvim-tree.actions.reloaders').reload_explorer() end, { noremap = true })

M.nvim_tree = require('nvim-tree')
M.opts = {
  remove_keymaps = true,
  view = {
    mappings = {
      list = { -- BEGIN_DEFAULT_MAPPINGS
        { key = { '<CR>', '<LeftMouse>' }, action = 'edit' },
        { key = '<C-e>', action = 'edit_in_place' },
        { key = 'E', action = 'edit_no_picker' },
        { key = { '<C-]>', '<RightMouse>', 'l' }, action = 'cd' },
        { key = '<M-v>', action = 'vsplit' },
        { key = '<M-x>', action = 'split' },
        { key = '<M-t>', action = 'tabnew' },
        { key = '<', action = 'prev_sibling' },
        { key = '>', action = 'next_sibling' },
        { key = 'P', action = 'parent_node' },
        { key = '<BS>', action = 'close_node' },
        { key = '<Tab>', action = 'preview' },
        { key = 'K', action = 'first_sibling' },
        { key = 'J', action = 'last_sibling' },
        { key = 'I', action = 'toggle_git_ignored' },
        { key = 'H', action = 'toggle_dotfiles' },
        { key = 'U', action = 'toggle_custom' },
        { key = '<C-r>', action = 'refresh' },
        { key = 'a', action = 'create' },
        { key = 'dd', action = 'remove' },
        { key = 't', action = 'trash' },
        { key = 'r', action = 'rename' },
        { key = 'R', action = 'full_rename' },
        { key = 'x', action = 'cut' },
        { key = 'c', action = 'copy' },
        { key = 'p', action = 'paste' },
        { key = 'y', action = 'copy_name' },
        { key = 'Y', action = 'copy_path' },
        { key = 'gy', action = 'copy_absolute_path' },
        { key = '[e', action = 'prev_diag_item' },
        { key = '[c', action = 'prev_git_item' },
        { key = ']e', action = 'next_diag_item' },
        { key = ']c', action = 'next_git_item' },
        { key = { '-', 'h' }, action = 'dir_up' },
        { key = 's', action = 'system_open' },
        { key = 'f', action = 'live_filter' },
        { key = 'F', action = 'clear_live_filter' },
        { key = 'q', action = 'close' },
        { key = 'W', action = 'collapse_all' },
        { key = 'E', action = 'expand_all' },
        { key = 'S', action = 'search_node' },
        { key = '.', action = 'run_file_command' },
        { key = '<C-k>', action = 'toggle_file_info' },
        { key = 'g?', action = 'toggle_help' },
        { key = 'm', action = 'toggle_mark' },
        { key = 'bmv', action = 'bulk_move' },
      } -- END_DEFAULT_MAPPINGS
    }
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      error = ' ',   -- xf659
      warning = ' ', -- xf529
      info = ' ',    -- xf7fc
      hint = ' ',    -- xf835
    }
  },
  renderer = {
    highlight_opened_files = 'name',
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        git = {
          unstaged = '',
          staged = '',
          unmerged = '',
          renamed = '隷',
          deleted = '',
          untracked = '',
          ignored = ''
        },
        default = ''
      }
    }
  },
}
M.nvim_tree.setup(M.opts)

return M
