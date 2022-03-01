local map = vim.api.nvim_set_keymap

map('n', '<Leader>tt', '<cmd>NvimTreeToggle<CR>', {noremap = true})
map('n', '<Leader>tc', '<cmd>NvimTreeClipboard<CR>', {noremap = true})
map('n', '<Leader>tq', '<cmd>NvimTreeClose<CR>', {noremap = true})
map('n', '<Leader>tff', '<cmd>NvimTreeFindFile<CR>', {noremap = true})
map('n', '<Leader>tft', '<cmd>NvimTreeFindFileToggle<CR>', {noremap = true})
map('n', '<Leader>tF', '<cmd>NvimTreeFocus<CR>', {noremap = true})
map('n', '<Leader>to', '<cmd>NvimTreeOpen<CR>', {noremap = true})
map('n', '<Leader>tr', '<cmd>NvimTreeRefresh<CR>', {noremap = true})
map('n', '<Leader>ts', '<cmd>NvimTreeResize<CR>', {noremap = true})

local g = vim.g
g.nvim_tree_highlight_opened_files = 2
g.nvim_tree_indent_markers = 1
g.nvim_tree_icons = {
  git = {
    unstaged = '',
    staged = '',
    unmerged = '',
    renamed = 'ﰲ',
    deleted = '',
    untracked = '',
    ignored = ''
  }
}

local tree_cb = require 'nvim-tree.config'.nvim_tree_callback
require 'nvim-tree'.setup {
  view = {
    auto_resize = true,
    mappings = {
      list = {
        { key = '<C-[>',                cb = tree_cb('dir_up') },
        { key = '<M-v>',                cb = tree_cb('vsplit') },
        { key = '<M-x>',                cb = tree_cb('split') },
        { key = '<M-t>',                cb = tree_cb('tabnew') },
        { key = '{',                    cb = tree_cb('first_sibling') },
        { key = '}',                    cb = tree_cb('last_sibling') },
        { key = 'X',                    cb = tree_cb('remove') },
      }
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
    },
  }
}
