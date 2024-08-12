---------
-- Git --
---------

return {
  "NeogitOrg/neogit",
  branch = "master",
  event = "VeryLazy",
  cmd = "Neogit",
  dependencies = {
    "sindrets/diffview.nvim",
  },
  config = function()
    vim.opt.fillchars = { diff = " " }
    local utils = require "utils.keymap.keymaps"
    local lmap = utils.set_leader_keymap

    local neogit = require "neogit"

    neogit.setup {
      commit_popup = {
        kind = "auto",
      },
      signs = {
        section = { " ", "" },
        item = { " ", "" },
      },
      integrations = { diffview = true },
      disable_builtin_notifications = true,
      disable_commit_confirmation = true,
    }

    local group = vim.api.nvim_create_augroup("MyCustomNeogitEvents", { clear = true })
    -- giving me an error
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeogitPushComplete",
      group = group,
      callback = require("neogit").close,
    })

    local keys = {
      {
        "<leader>gs",
        "<cmd>Neogit status<CR>",
        desc = "Git status",
      },
      "<leader>gC",
      {
        "<leader>gd",
        "<cmd>Neogit diff<CR>",
        desc = "Git diff",
      },
      { "<leader>gcc", "<cmd>Neogit commit<CR>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git pull" },
      { "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git push" },
      { "<leader>gr", "<cmd>Neogit rebase<CR>", desc = "Git rebase" },
      { "<leader>gl", "<cmd>Neogit log<CR>", desc = "Git log" },
    }

    lmap("gss", function()
      return neogit.open {
        cwd = vim.fn.expand "%:p:h",
        kind = "auto",
      }
    end, "[Split] Neogit Git status")

    lmap("gL", function()
      return neogit.open { "log" }
    end, "Neogit Log")
    lmap("gsT", function()
      return neogit.open()
    end, "[Tab] Neogit Git status")

    lmap("gcc", function()
      return neogit.open { "commit" }
    end, "Neogit Git commit")
  end,
}
