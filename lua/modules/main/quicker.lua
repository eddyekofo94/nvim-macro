return {
  "stevearc/quicker.nvim",
  enabled = true,
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  config = function()
    local map = require("utils.keymap.keymaps").set_keymap

    local quicker = require "quicker"

    map("n", "<leader>qq", function()
      quicker.toggle()
    end, {
      desc = "Toggle quickfix",
    })
    map("n", "<leader>ql", function()
      quicker.toggle { loclist = true }
    end, {
      desc = "Toggle loclist",
    })

    quicker.setup {
      on_qf = function(bufnr)
        map("n", "q", function()
          quicker.close()
        end, { buffer = bufnr, desc = "qf close" })
      end,
      keys = {
        {
          "+",
          function()
            quicker.expand { before = 2, after = 2, add_to_existing = true }
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            quicker.collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    }
  end,
}
