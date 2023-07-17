if vim.g.loaded_coplilot then
  return
end
vim.g.loaded_coplilot = true

local copilot = require('copilot')
local suggestion = require('copilot.suggestion')
local utils = require('utils')

copilot.setup({
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = false,
    },
  },
  filetypes = {
    markdown = true,
    help = true,
  },
})

vim.defer_fn(function()
  utils.keymap.amend('i', '<C-f>', function(fallback)
    if suggestion.is_visible() then
      suggestion.accept()
    else
      fallback()
    end
  end)
end, 10)
