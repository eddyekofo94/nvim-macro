return {
  "folke/lsp-trouble.nvim",
  event = "LspAttach",
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" },
  config = function()
    -- mapped to <space>dt -- this shows a list of diagnostics
    require("trouble").setup {
      position = "bottom", -- position of the list can be: bottom, top, left, right
      focus = true,
      group = true, -- group results by file
      padding = true, -- add an extra new line on top of the list
      -- win_config = { border = "single" }, -- window configuration for floating windows. See |nvim_open_win()|.
      auto_close = true, -- automatically close the list when you have no diagnostics
      auto_fold = false, -- automatically fold a file trouble list at creation
      cycle_results = false, -- cycle item list when reaching beginning or end of list
      height = 12, -- height of the trouble list
      mode = "document_diagnostics",
      action_keys = {
        -- key mappings for actions in the trouble list
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
        jump_close = { "o" }, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = { "zM", "zm" }, -- close all folds
        open_folds = { "zR", "zr" }, -- open all folds
        toggle_fold = { "zA", "za" }, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j", -- next item
      },
    }
  end,
  keys = {
    {
      "<leader>dx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    { "<leader>dD", "<cmd>Trouble document_diagnostics<cr>", desc = "[D]ocument Diagnostics" },
    -- { "<leader>dW", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "[W]orkspace Diagnostics" },
    -- { "<leader>dl", "<cmd>TroubleToggle loclist<cr>", desc = "[L]ocation List" },
    { "<leader>dq", "<cmd>Trouble qflist toggle<cr>", desc = "[Q]uickfix List" },
    {
      "<leader>dr",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>dt",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble Toggle",
    },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").previous { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Previous trouble/quickfix item",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next { skip_groups = true, jump = true }
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Next trouble/quickfix item",
    },
  },
}
