local ts_context = require('treesitter-context')

vim.keymap.set('n', '[C', ts_context.go_to_context)
ts_context.setup({
  max_lines = 4,
  min_window_height = 8,
  mode = 'topline',
})
