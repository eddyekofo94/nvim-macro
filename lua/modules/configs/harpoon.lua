-- local nmap = require("core.utils").nmap

local wk = require "which-key"
local harpoon = require "harpoon"
local mark = require "harpoon.mark"

harpoon.setup {}

wk.register({
  a = { require("harpoon.mark").add_file, "Harpoon add file" },
  -- H = { ":Telescope harpoon marks<cr>", "Harpoon menu" },
  -- H = { require("harpoon.ui").toggle_quick_menu, "Harpoon menu" },
  ["bd"] = {
    function()
      return mark.rm_file
    end,
    "Harpoon remove file",
  },
}, { prefix = "<leader>" })

-- nmap { "n", "<c-p>", require("harpoon.ui").nav_prev, "Harpoon previous file" }
-- nmap { "n", "<c-n>", require("harpoon.ui").nav_next, "Harpoon next file" }

-- for i = 1, 5 do
--   nmap {
--     "n",
--     string.format("<space>%s", i),
--     function()
--       require("harpoon.ui").nav_file(i)
--     end,
--     string.format("Harpoon get file %s", i),
--   }
-- end
