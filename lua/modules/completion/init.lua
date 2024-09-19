return {
  -- {
  --   "hrsh7th/nvim-cmp",
  --   lazy = false,
  --   enabled = false,
  --   config = function()
  --     -- require "configs.nvim-cmp"
  --
  --     require "modules.configs.cmp"
  --   end,
  --   opts = function(_, opts)
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, {
  --       name = "lazydev",
  --       group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --     })
  --   end,
  --   dependencies = {
  --     { "L3MON4D3/LuaSnip" },
  --     { "ray-x/cmp-treesitter" },
  --     { "dmitmel/cmp-cmdline-history" },
  --     { "hrsh7th/cmp-nvim-lsp-document-symbol" },
  --     { "hrsh7th/cmp-path" },
  --     { "hrsh7th/cmp-buffer" }, -- Optional
  --     { "lukas-reineke/cmp-rg" },
  --     {
  --       "onsails/lspkind.nvim",
  --       lazy = true,
  --       opts = {
  --         mode = "symbol",
  --         symbol_map = {
  --           Array = "󰅪",
  --           Boolean = "⊨",
  --           Class = "󰌗",
  --           Constructor = "",
  --           Key = "󰌆",
  --           Namespace = "󰅪",
  --           Null = "NULL",
  --           Number = "#",
  --           Object = "󰀚",
  --           Package = "󰏗",
  --           Property = "",
  --           Reference = "",
  --           Snippet = "",
  --           String = "󰀬",
  --           TypeParameter = "󰊄",
  --           Unit = "",
  --         },
  --         menu = {},
  --       },
  --       config = function(_, opts)
  --         require("lspkind").init(opts)
  --       end,
  --     },
  --   },
  -- },

  {
    "hrsh7th/cmp-calc",
    event = "InsertEnter",
    dependencies = "hrsh7th/nvim-cmp",
  },

  {
    "hrsh7th/cmp-cmdline",
    event = "CmdlineEnter",
    dependencies = "hrsh7th/nvim-cmp",
  },

  {
    "hrsh7th/cmp-nvim-lsp",
    event = "InsertEnter",
    dependencies = "hrsh7th/nvim-cmp",
  },

  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    event = "InsertEnter",
    dependencies = "hrsh7th/nvim-cmp",
  },

  {
    "tzachar/cmp-fuzzy-path",
    build = "fd --version || find --version",
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = {
      "tzachar/fuzzy.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },

  {
    "hrsh7th/cmp-buffer",
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = "hrsh7th/nvim-cmp",
  },

  {
    "rcarriga/cmp-dap",
    lazy = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "hrsh7th/nvim-cmp",
    },
  },

  {
    "saadparwaiz1/cmp_luasnip",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "L3MON4D3/LuaSnip",
    },
  },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   enabled = false,
  --   event = "InsertEnter",
  --   config = function()
  --     require "configs.copilot"
  --   end,
  -- },

  -- {
  --   "L3MON4D3/LuaSnip",
  --   enabled = false,
  --   build = "make install_jsregexp",
  --   event = "ModeChanged *:[iRss\x13vV\x16]*",
  --   config = function()
  --     require "configs.LuaSnip"
  --   end,
  -- },
}
