return {
  {
    "kylechui/nvim-surround",
    enabled = false,
    keys = {
      "ys",
      "ds",
      "cs",
      { "S", mode = "x" },
      { "<C-g>s", mode = "i" },
    },
    config = function()
      require "configs.nvim-surround"
    end,
  },

  {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "StdinReadPre" },
  },

  {
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require "configs.ultimate-autopair"
    end,
  },

  {
    "chrisgrieser/nvim-spider",
    opts = {
      skipInsignificantPunctuation = true,
    },
    event = "VeryLazy",
    keys = { "w", "e", "b", "ge" },
    config = function()
      require "modules.configs.spider"
    end,
  },
  {
    "junegunn/vim-easy-align",
    enabled = false,
    keys = {
      { "gl", mode = { "n", "x" } },
      { "gL", mode = { "n", "x" } },
    },
    config = function()
      require "configs.vim-easy-align"
    end,
  },

  {
    "andymass/vim-matchup",
    enabled = false,
    event = { "BufReadPre", "StdinReadPre", "TextChanged" },
    init = function()
      -- Disable matchit and matchparen
      vim.g.loaded_matchparen = 0
      vim.g.loaded_matchit = 0
    end,
    config = function()
      require "configs.vim-matchup"
    end,
  },
  {
    "nguyenvukhang/nvim-toggler",
    keys = {
      { "<leader>ii", desc = "Toggle Word" },
    },
    config = function()
      require("nvim-toggler").setup {
        remove_default_keybinds = true,
      }
      vim.keymap.set({ "n", "v" }, "<leader>ii", require("nvim-toggler").toggle, { desc = "Toggle a Word" })
    end,
  },
}
