return {
  "FabijanZulj/blame.nvim",
  event = "VeryLazy",
  enable = true,
  config = true,
  keys = {
    {
      "<leader>gB",
      "<cmd>BlameToggle virtual<CR>",
      "Git blame side",
    },
  },
}
