return {
  "folke/flash.nvim",
  event = "VeryLazy",
  enabled = true,
  config = function()
    local smart_close_filetypes = {
      "NeogitStatus",
      "neogit*",
      "qf",
      "nofile",
      "quickfix",
      "term",
      "lazygit",
      "dap-repl",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_breakpoints",
      "dapui_console",
      "dapui_watches",
      "dapui_repl",
      "undotree",
      "noice",
      "messages",
      "help",
      "Trouble",
      "diffview",
      "telescope",
      "lazy",
      "Outline",
      "TelescopePrompt",
      "TelescopeResults",
      "TelescopePreview",
    }
    if vim.tbl_contains(smart_close_filetypes, vim.bo.filetype) then
      return false
    end
    return true
  end,
  -- @type Flash.Config
  opts = {
    search = {
      multi_window = true,
    },
  },
  keys = {
    {
      "ss",
      mode = { "n", "o", "x" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
    {
      "<leader>dd",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump {
          matcher = function(win)
            ---@param diag Diagnostic
            return vim.tbl_map(function(diag)
              return {
                pos = { diag.lnum + 1, diag.col },
                end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
              }
            end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
          end,
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function()
              vim.api.nvim_win_set_cursor(match.win, match.pos)
              vim.diagnostic.open_float()
            end)
            state:restore()
          end,
        }
      end,
      desc = "Flash Diagnostic",
    },
  },
}
