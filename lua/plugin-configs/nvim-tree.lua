local map = vim.api.nvim_set_keymap

map('n', '<Leader>tt', [[<cmd>lua require('nvim-tree').toggle(false, false)<CR>]], {noremap = true})
map('n', '<Leader>tc', [[<cmd>lua require('nvim-tree.actions.copy-paste').print_clipboard()<CR>]], {noremap = true})
map('n', '<Leader>tq', [[<cmd>lua require('nvim-tree.view').close()<CR>]], {noremap = true})
map('n', '<Leader>tff', [[<cmd>lua require('nvim-tree').find_file(true)<CR>]], {noremap = true})
map('n', '<Leader>tft', [[<cmd>lua require('nvim-tree').toggle(true, false)<CR>]], {noremap = true})
map('n', '<Leader>to', [[<cmd>lua require('nvim-tree').open()<CR> ]], {noremap = true})
map('n', '<Leader>tr', [[<cmd>lua require('nvim-tree.actions.reloaders').reload_explorer()<CR>]], {noremap = true})

local g = vim.g
g.nvim_tree_highlight_opened_files = 2
g.nvim_tree_indent_markers = 1
g.nvim_tree_icons = {
  git = {
    unstaged = '',
    staged = '',
    unmerged = '',
    renamed = '隷',
    deleted = '',
    untracked = '',
    ignored = ''
  }
}

require 'nvim-tree'.setup {
  view = {
    auto_resize = true,
    mappings = {
      list = {
        { key = '<C-[>',                action = 'dir_up' },
        { key = '<M-v>',                action = 'vsplit' },
        { key = '<M-x>',                action = 'split' },
        { key = '<M-t>',                action = 'tabnew' },
        { key = '{',                    action = 'first_sibling' },
        { key = '}',                    action = 'last_sibling' },
        { key = 'X',                    action = 'remove' },
        { key = 'W',                    action = '' },
        { key = 'zM',                   action = 'collapse_all' },
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
    }
  }
}
