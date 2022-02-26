local execute = vim.cmd

execute(':command TT NvimTreeToggle')
execute(':command TC NvimTreeClipboard')
execute(':command TQ NvimTreeClose')
execute(':command TFF NvimTreeFindFile')
execute(':command TFFT NvimTreeFindFileToggle')
execute(':command TF NvimTreeFocus')
execute(':command TO NvimTreeOpen')
execute(':command TR NvimTreeRefresh')
execute(':command TS NvimTreeResize')

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
