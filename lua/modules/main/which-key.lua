return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    delay = 500,
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show { global = false }
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require "which-key"
    wk.add {
      { "<leader>f", group = "Fzf" }, -- group
      { "<leader>s", group = "Search [Telescope]" }, -- group
      { "<leader>l", group = "LSP" }, -- group
      { "<leader>c", group = "Code" }, -- group
      { "<leader>t", group = "Terminal" }, -- group
      { "<leader>d", group = "Diagonostics" }, -- group
      { "<leader>b", group = "Buffers" }, -- group
      { "<leader>T", group = "TODO" },
      { "<leader>v", group = "Focus" },
      { "<leader>g", group = "Git" },
      { "<leader>gw", group = "Git Worktrees" },
      { "<leader>f1", hidden = true }, -- hide this keymap
      { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
      {
        "<leader>b",
        group = "buffers",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
    }
  end,
}
