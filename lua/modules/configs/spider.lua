local utils = require "utils.keymap.keymaps"
local keymap, nxo = utils.set_keymap, utils.nxo

keymap(nxo, "w", function()
  require("spider").motion("w", { skipInsignificantPunctuation = false })
end, "Spider-w")
keymap(nxo, "e", "<cmd>lua require('spider').motion('e')<CR>", "Spider-e")
keymap(nxo, "b", "<cmd>lua require('spider').motion('b')<CR>", "Spider-b")
keymap(nxo, "ge", "<cmd>lua require('spider').motion('ge')<CR>", "Spider-ge")
