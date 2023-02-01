local tmux = require('tmux')
tmux.setup({
  copy_sync = {
    enable = false,
  },
  navigation = {
    cycle_navigation = false,
    enable_default_keybindings = false,
  },
  resize = {
    enable_default_keybindings = false,
  },
})

vim.keymap.set('n', '<M-h>', tmux.move_left, { noremap = true })
vim.keymap.set('n', '<M-j>', tmux.move_bottom, { noremap = true })
vim.keymap.set('n', '<M-k>', tmux.move_top, { noremap = true })
vim.keymap.set('n', '<M-l>', tmux.move_right, { noremap = true })
