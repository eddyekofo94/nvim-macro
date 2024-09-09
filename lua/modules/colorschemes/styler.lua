return {
  "folke/styler.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    require("styler").setup {
      themes = {
        markdown = { colorscheme = "macro" },
        help = { colorscheme = "catppuccin", background = "dark" },
      },
    }
  end,
}
