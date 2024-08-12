return {
  { import = "modules.mini" },
  { import = "modules.edit" },
  { import = "modules.navigation" },
  { import = "modules.git" },
  { import = "modules.lsp" },
  { import = "modules.main" },
  {
    "NvChad/nvterm",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("nvterm").setup()
      require "modules.configs.nvterm"
    end,
  },
  {
    "folke/noice.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require "modules.configs.noice"
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>Tq", "<cmd>TodoQuickFix<cr>", desc = "Search TODO" },
      {
        "]t",
        "<cmd>lua require('todo-comments').jump_next()<cr>",
        { desc = "Next todo comment" },
      },
      {
        "[t",
        "<cmd>lua require('todo-comments').jump_prev()<cr>",
        { desc = "Previous todo comment" },
      },
    },
    opts = require "modules.configs.todo-comments",
  },
  {
    "ThePrimeagen/harpoon",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require "modules.configs.harpoon"
    end,
  },
  {
    "smjonas/live-command.nvim",
    enabled = false,
    event = "CmdlineEnter",
    config = function()
      require("live-command").setup {
        commands = {
          Norm = { cmd = "norm" },
        },
      }
    end,
  },

  {
    "lcheylus/overlength.nvim",
    event = "BufReadPre",
    enabled = true,
    config = function()
      require("overlength").setup {
        bg = "#840000",
        default_overlength = 80, -- INFO: seems to not work
        disable_ft = { "help", "dashboard", "which-key", "lazygit", "term" },
      }
      require("overlength").set_overlength({ "go", "lua", "vim" }, 120)
      require("overlength").set_overlength({ "cpp", "bash" }, 80)
      require("overlength").set_overlength({ "rust", "python" }, 100)
    end,
  },

  {
    "tris203/precognition.nvim",
    enabled = false,
    --event = "VeryLazy",
    opts = {
      -- startVisible = true,
      -- showBlankVirtLine = true,
      -- highlightColor = { link = "Comment" },
      -- hints = {
      --      Caret = { text = "^", prio = 2 },
      --      Dollar = { text = "$", prio = 1 },
      --      MatchingPair = { text = "%", prio = 5 },
      --      Zero = { text = "0", prio = 1 },
      --      w = { text = "w", prio = 10 },
      --      b = { text = "b", prio = 9 },
      --      e = { text = "e", prio = 8 },
      --      W = { text = "W", prio = 7 },
      --      B = { text = "B", prio = 6 },
      --      E = { text = "E", prio = 5 },
      -- },
      -- gutterHints = {
      --     G = { text = "G", prio = 10 },
      --     gg = { text = "gg", prio = 9 },
      --     PrevParagraph = { text = "{", prio = 8 },
      --     NextParagraph = { text = "}", prio = 8 },
      -- },
    },
  },
  {
    -- "ahmedkhalf/project.nvim",
    --  INFO: 2024-06-17 - nvim-telescope/telescope-project.nvim
    -- natecraddock/workspaces.nvim -- look into this?
    "LennyPhoenix/project.nvim", -- Temporary switch to fork
    branch = "fix-get_clients",
    -- can't use 'opts' because module has non standard name 'project_nvim'
    config = function()
      require("project_nvim").setup {
        scope_chdir = "global",
        patterns = {
          ".git",
          "package.json",
          "go.mod",
          "Makefile",
          "pom.xml",
          "requirements.yml",
          "pyrightconfig.json",
          "pyproject.toml",
        },
        detection_methods = { "lsp", "pattern" },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    -- INFO: disabled for now
    enabled = false,
    event = "BufWinEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = require "modules.configs.illuminate",
  },
  {
    "utilyre/sentiment.nvim",
    version = "*",
    enabled = true,
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },
  {
    "andymass/vim-matchup",
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "smoka7/multicursors.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    opts = {},
    cmd = {
      "MCstart",
      "MCvisual",
      "MCclear",
      "MCpattern",
      "MCvisualPattern",
      "MCunderCursor",
    },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>mc",
        "<cmd>MCstart<cr>",
        desc = "Multi cursor",
      },
    },
  },
  {
    "nacro90/numb.nvim",
    event = "VeryLazy",
    opts = {
      show_numbers = true,
      show_cursorline = true,
      number_only = false,
      centered_peeking = true,
    },
  },
  {
    "folke/zen-mode.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "folke/twilight.nvim",
        config = function()
          require("twilight").setup {
            context = -1,
            treesitter = true,
          }
        end,
      },
    },
    config = require "modules.configs.zen",
  },

  {
    "NMAC427/guess-indent.nvim",
    event = "VeryLazy",
    enabled = true,
    config = function()
      require("guess-indent").setup {}
      local guess_indent = require "guess-indent"
      guess_indent.set_from_buffer(_, _, true)
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    -- event = "VeryLazy",
    lazy = false,
    opts = require("modules.configs.ufo").opts,
    init = require("modules.configs.ufo").init(),
    config = function(opts)
      require("modules.configs.ufo").config(opts)
    end,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-highlight-colors").setup {
        ---Render style
        ---@usage 'background'|'foreground'|'virtual'
        render = "background",
        ---Highlight named colors, e.g. 'green'
        enable_named_colors = false,
      }
    end,
  },
  {
    "arsham/indent-tools.nvim",
    event = "VeryLazy",
    dependencies = {
      "arsham/arshlib.nvim",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = true,
    keys = { "]i", "[i" },
    -- or to provide configuration
    -- config = { normal = {..}, textobj = {..}},
  },
  {
    -- INFO: does this work?
    "ironhouzi/starlite-nvim",
    event = "WinEnter",
    config = function()
      local map = vim.keymap.set
      local default_options = { silent = true }
      map("n", "*", ":lua require'starlite'.star()<cr>", default_options)
      map("n", "g*", ":lua require'starlite'.g_star()<cr>", default_options)
      map("n", "#", ":lua require'starlite'.hash()<cr>", default_options)
      map("n", "g#", ":lua require'starlite'.g_hash()<cr>", default_options)
    end,
  },
  {
    "ashfinal/qfview.nvim",
    enabled = false,
    event = "UIEnter",
    opts = {},
  },
  {
    "gabrielpoca/replacer.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = { rename_files = true },
    keys = {
      {
        "<leader>qf",
        function()
          require("replacer").run()
        end,
        desc = "run replacer.nvim",
      },
      {
        "<leader>qs",
        function()
          require("replacer").save()
        end,
        desc = "save replacer.nvim",
      },
    },
  },
  {
    "ten3roberts/qf.nvim",
    enabled = false,
    config = function()
      require("qf").setup {}
    end,
  },
  {
    -- INFO: jj == esc
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = true,
    branch = "main", -- change to alpha if satisfied with its updates
    event = { "WinNew" },
    opts = require "modules.configs.winsep",
    config = true,
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    config = true,
    opts = require "modules.configs.early-retirement",
  },

  {
    "VidocqH/auto-indent.nvim",
    opts = {},
  },

  {
    "kylechui/nvim-surround",
    enabled = false,
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" } },
      { "S", mode = "x" },
    },
    config = function()
      require "modules.configs.nvim-surround"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "dreamsofcode-io/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
          require("dap-go").setup(opts)
        end,
      },
    },
  },
}
