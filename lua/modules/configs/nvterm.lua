local nmap = require("utils.keymap.keymaps").set_n_keymap
local map = require("utils.keymap.keymaps").set_keymap

map({ "t", "n" }, "<A-i>", function()
  return require("nvterm.terminal").toggle "float"
end, "Toggle floating term")

map({ "t", "n" }, "<A-o>", function()
  return require("nvterm.terminal").toggle "horizontal"
end, "Toggle horizontal term")

map({ "t", "n" }, "<A-v>", function()
  return require("nvterm.terminal").toggle "vertical"
end, "Toggle vertical term")

nmap("<leader>tf", function()
  return require("nvterm.terminal").new "float"
end, "Terminal new float term")

nmap("<leader>th", function()
  return require("nvterm.terminal").new "horizontal"
end, "Terminal new hor term")

nmap("<leader>tv", function()
  return require("nvterm.terminal").new "vertical"
end, "Terminal new ver term")
