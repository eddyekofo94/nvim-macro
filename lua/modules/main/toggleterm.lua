return {
  {
    "akinsho/toggleterm.nvim",
    enabled = false,
    version = "*",
    config = function()
      local Utils = require "utils.keymap.keymaps"
      -- fzf is just an example
      require("toggleterm").setup {
        shade_filetypes = { "none", "fzf" },
      }
    end,
  },
}
