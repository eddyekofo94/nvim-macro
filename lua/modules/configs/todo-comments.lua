local keymap = require("utils.keymap.keymaps").set_keymap

local opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BREAK", "BUG", "FIXIT", "ISSUE", "ERROR" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = {
      icon = " ",
      alt = { "REFACTOR", "REFC", "OPTIM", "PERFORMANCE", "OPTIMIZE" },
    },
    NOTE = { icon = " ", color = "hint", alt = { "INFO", "REVIEW" } },
    EXAMPLE = { icon = "󰄛 ", color = "hint", alt = { "E.G." } },
    CLEAN_UP = { icon = " ", color = "error", alt = { "CLEAN", "DISABLED" } },
    DEBUG = { icon = " ", color = "error" },
    TEST = {
      icon = "󰙨 ",
      color = "test",
      alt = { "TESTING", "PASSED", "FAILED" },
    },
  },
}

keymap("n", "<leader>Tt", "<cmd>TodoTelescope<cr>", "Search TODO")
return opts
