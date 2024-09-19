return {
  {
    "olexsmir/gopher.nvim",
    enabled = false,
    ft = { "go", "gomod" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("gopher.dap").setup()

      local lmap = require("utils.keymap.keymaps").set_leader_keymap

      lmap("cTT", "<cmd>GoTestAdd<CR>", "Generate one test for a specific function/method")
      lmap("cTA", "<cmd>GoTestsAll<CR>", "Generate all tests for all functions/methods in current file")
      lmap("cTE", "<cmd>GoTestsExp<CR>", "Generate tests only for exported functions/methods in current file")
      lmap("cTi", "<cmd>GoIfErr<CR>", "Setup nvim-dap for go in one line")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}
