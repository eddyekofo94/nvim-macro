local maps = require("utils").empty_map_table()
local Telescope = require "utils.telescope"
local keymap_utils = require "utils.keymap.keymaps"

maps.n["<leader>p"] = {
  Telescope.find("files", { cwd = "%:p:h" }),
  desc = "Find files current dir",
}
M.refactoring = {
  x = {
    ["<leader>ro"] = { "<cmd>Refactor<CR>" },
    ["<leader>rf"] = { "<cmd>Refactor extract_to_file<cr>", "extract to file" },
    ["<leader>rv"] = { "<cmd>Refactor extract_var<cr>", "extract var" },
    ["<leader>ri"] = {
      "<cmd>Refactor inline_var<cr>",
      "inline variable",
      -- mode = { "n", "x" },
    },
  },
  n = {
    ["<leader>ri"] = {
      "<cmd>Refactor inline_var<cr>",
      "inline variable",
      -- mode = { "n", "x" },
    },
    ["<leader>rb"] = {
      "<cmd>Refactor extract_block<cr>",
      "extract block",
    },
    ["<leader>rbf"] = {
      "<cmd>Refactor extract_block_to_file<cr>",
      "extract block to file",
    },
  },
  v = {
    ["<leader>rr"] = {
      function()
        require("telescope").extensions.refactoring.refactors()
      end,
      -- "<cmd>lua require('refactoring').select_refactor()<CR>",
      "Select refactor",
    },
  },
}

keymap_utils.set_mappings(maps)
