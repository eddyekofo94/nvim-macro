return {
  "johmsalas/text-case.nvim",
  config = function()
    require("textcase").setup {}
    require("telescope").load_extension "textcase"
  end,
  keys = { { "ga.", mode = { "n", "v" }, "<cmd>TextCaseOpenTelescope<CR>", desc = "Telescope text-case" } },
  cmd = { "TextCaseOpenTelescope" },
}
