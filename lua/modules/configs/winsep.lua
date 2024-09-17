local opts = {
  highlight = {
    bg = vim.api.nvim_get_hl(0, { name = "EndOfBuffer" })["bg"],
    fg = vim.api.nvim_get_hl(0, { name = "String" })["fg"],
  },
  -- interval = 50,
  no_exec_files = {
    "LazyGit",
    "noice",
    "notify",
    "Trouble",
    "packer",
    "TelescopePrompt",
    "mason",
    "CompetiTest",
    "NvimTree",
  },
  --  NOTE: 2023-10-23 13:03 PM - "⎯"
  symbols = { "─", "│", "┌", "┐", "└", "┘" },

  -- disable if I only have 2 files open
  create_event = function()
    local winsep = require "colorful-winsep"
    local win_n = require("colorful-winsep.utils").calculate_number_windows()
    if win_n == 2 then
      winsep.NvimSeparatorDel()
    end
  end,
}

return opts
