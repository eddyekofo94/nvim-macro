return {
  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      local worktree = require "git-worktree"
      local utils = require "utils.keymap.keymaps"
      local Buffer = require "utils.buffer"
      local map = utils.set_keymap

      worktree.setup {
        change_directory_command = "cd", -- default: "cd",
        update_on_change = true, -- default: true,
        update_on_change_command = "e .", -- default: "e .",
        clearjumps_on_change = true, -- default: true,
        autopush = false, -- default: false,
      }

      map("n", "<leader>gwc", function()
        require("telescope").extensions.git_worktree.create_git_worktree()
      end, "Git Worktree create")

      map("n", "<Leader>gww", function()
        require("telescope").extensions.git_worktree.git_worktrees()
      end, "Git worktree list")

      --  INFO: 2024-05-28 - Fix this when you get a chace
      -- worktree.on_tree_change(function(op, metadata)
      --   if op == worktree.Operations.Switch then
      --     utils.log("Switched from " .. metadata.prev_path .. " to " .. metadata.path, "Git Worktree")
      --     Buffer.close_all_buffers()
      --     vim.cmd "e"
      --   end
      -- end)
    end,
  },
}
