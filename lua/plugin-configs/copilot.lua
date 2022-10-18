local M = {}

M.settings = {
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 75,
    keymap = {
     accept = '<C-j>',
     next = '<C-j>',
     prev = '<C-j>',
     dismiss = '<C-j>',
    },
  },
}

vim.defer_fn(function ()
  require('copilot').setup(M.settings)
end, 100)

return M
