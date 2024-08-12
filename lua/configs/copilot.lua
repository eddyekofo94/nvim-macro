if vim.g.loaded_coplilot then
  return
end
vim.g.loaded_coplilot = true

local copilot = require "copilot"
local copilot_client = require "copilot.client"
local suggestion = require "copilot.suggestion"
local utils = require "utils"

copilot.setup {
  suggestion = {
    auto_trigger = true,
    debounce = 500,
    keymap = {
      accept = false,
    },
  },
  filetypes = {
    markdown = true,
    help = true,
  },
}

vim.defer_fn(function()
  utils.keymap.keymaps.amend("i", "<C-f>", function(fallback)
    if suggestion.is_visible() then
      suggestion.accept()
    else
      fallback()
    end
  end)
end, 10)

local _buf_attach = copilot_client.buf_attach

---Do not attach copilot to large files
---@param force? boolean
---@return nil
---@diagnostic disable-next-line: duplicate-set-field
function copilot_client.buf_attach(force)
  if vim.b.bigfile and not force then
    return
  end
  return _buf_attach(force)
end
