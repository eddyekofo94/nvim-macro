return {
  {
    "sindrets/diffview.nvim",
    opts = {
      use_icons = false,
      enhanced_diff_hl = true,
      default_args = {
        DiffviewOpen = { "--untracked-files=no" },
        DiffviewFileHistory = { "--base=LOCAL" },
      },
    },
    cmd = {
      "DiffviewFileHistory",
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("diffview").setup {
        default = {
          disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
        },
        merge_tool = {
          disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
        },
      }
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    enabled = true,
    keys = {
      {
        "<leader>G",
        function()
          return vim.cmd [[LazyGit]]
        end,
        desc = "LazyGit",
      },
    },
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
