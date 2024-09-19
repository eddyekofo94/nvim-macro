return {
  "echasnovski/mini.completion",
  enabled = false,
  config = function()
    require("mini.completion").setup {
      fallback_action = function() end,
      set_vim_settings = false,
      window = {
        info = { border = "single" },
        signature = { border = "single" },
      },
    }
  end,
}
