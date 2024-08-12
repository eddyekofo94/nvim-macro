return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cmd = {
      "TSInstall",
      "TSInstallSync",
      "TSInstallInfo",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSBufEnable",
      "TSBufToggle",
      "TSEnable",
      "TSToggle",
      "TSModuleInfo",
      "TSEditQuery",
      "TSEditQueryUserAfter",
    },
    event = "FileType",
    config = function()
      vim.schedule(function()
        require "configs.nvim-treesitter"
      end)
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "RRethy/nvim-treesitter-endwise",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
          multiline_threshold = 20, -- Maximum number of lines to show for a single context
          trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          zindex = 20, -- The Z-index of the context window
          mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
          on_attach = function()
            local disabled_filetypes = { "markdown", "vim" }
            -- local ft = vim.bo.ft:gsub("^%l", string.lower)
            local ft = vim.bo.filetype

            return not vim.tbl_contains(disabled_filetypes, ft)
          end,
          patterns = {
            default = {
              "class",
              "function",
              "method",
              "for", -- These won't appear in the context
              "while",
              "if",
              "switch",
              "case",
              "const",
            },
          },
        },
        config = function(_, opts)
          local context = require "treesitter-context"
          context.setup(opts)
        end,
      },
    },
  },

  {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = { "<M-C-K>", "<M-NL>", "g<M-NL>" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require "configs.treesj"
    end,
  },

  {
    "Eandrju/cellular-automaton.nvim",
    event = "FileType",
    cmd = "CellularAutomaton",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
