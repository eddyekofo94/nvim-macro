local tmux = require('tmux')
local utils = require('utils')

---@diagnostic disable-next-line: redundant-parameter
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

vim.keymap.set('n', '<M-h>', utils.keymap.count_wrap(tmux.move_left))
vim.keymap.set('n', '<M-j>', utils.keymap.count_wrap(tmux.move_bottom))
vim.keymap.set('n', '<M-k>', utils.keymap.count_wrap(tmux.move_top))
vim.keymap.set('n', '<M-l>', utils.keymap.count_wrap(tmux.move_right))
