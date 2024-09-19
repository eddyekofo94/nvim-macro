return {
  "echasnovski/mini.sessions",
  lazy = false,
  enabled = true,
  priority = 100,
  event = "VimEnter",
  config = function()
    require("mini.basics").setup {
      basic = true,
      extra_ui = true,
      win_borders = "solid",
      mappings = {
        windows = false,
      },
    }
  end,
}
