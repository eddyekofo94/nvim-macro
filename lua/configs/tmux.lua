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

---Wrap tmux navigation functions to allow for count prefix
---@param fn function
---@return function
local function movement_wrap(fn)
  return function()
    for _ = 1, vim.v.count1 do
      fn()
    end
  end
end

vim.keymap.set('n', '<M-h>', movement_wrap(tmux.move_left))
vim.keymap.set('n', '<M-j>', movement_wrap(tmux.move_bottom))
vim.keymap.set('n', '<M-k>', movement_wrap(tmux.move_top))
vim.keymap.set('n', '<M-l>', movement_wrap(tmux.move_right))
