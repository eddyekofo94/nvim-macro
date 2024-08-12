return {
  "echasnovski/mini.surround",
  enabled = true,
  event = "BufReadPre",
  opts = {
    search_method = "cover_or_next",
    highlight_duration = 2000,
    mappings = {
      add = "ys",
      delete = "ds",
      replace = "cs",
      highlight = "",
      find = "",
      find_left = "",
      update_n_lines = "",
    },
    custom_surroundings = {
      ["("] = { output = { left = "( ", right = " )" } },
      ["["] = { output = { left = "[ ", right = " ]" } },
      ["{"] = { output = { left = "{ ", right = " }" } },
      ["<"] = { output = { left = "<", right = ">" } },
      ["|"] = { output = { left = "|", right = "|" } },
      ["%"] = { output = { left = "<% ", right = " %>" } },
    },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)
    local map = require("utils.keymap.keymaps").set_keymap
    map("n", "ysS", "s$", { remap = true, desc = "Surround until end of line" })
  end,
}
