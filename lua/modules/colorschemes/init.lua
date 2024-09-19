return {
  { import = "modules.colorschemes.lackluster" },
  { import = "modules.colorschemes.catppuccin" },
  { import = "modules.colorschemes.styler" },
  { "sainnhe/everforest" },
  { "sainnhe/gruvbox-material" },
  { "projekt0n/github-nvim-theme" },
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/edge" },
  { "blazkowolf/gruber-darker.nvim" },

  {
    "f-person/auto-dark-mode.nvim",
    enabled = true,
    lazy = false,
    config = function()
      require("auto-dark-mode").setup {
        update_interval = 1000,
        set_dark_mode = function()
          vim.cmd.colorscheme "gruvbox"
          vim.g.transparency = false
        end,
        set_light_mode = function()
          vim.g.colorscheme = "gruvbox_light"
          vim.g.transparency = true
        end,
      }
    end,
  },
  {
    "dgox16/oldworld.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd.colorscheme "oldworld"
    end,
    config = function()
      require("oldworld").setup {
        styles = {
          booleans = { italic = true, bold = true },
        },
        integrations = {
          hop = true,
          telescope = false,
        },
        highlight_overrides = {
          StatusLineNC = { link = "StatusLineTermNC" },
        },
      }
    end,
  },
  {
    "Verf/deepwhite.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      -- vim.cmd [[colorscheme deepwhite]]
    end,
  },
  -- Lazy
  {
    "vague2k/vague.nvim",
    init = function()
      vim.cmd.colorscheme "vague"
    end,
    config = function()
      require("vague").setup {
        -- optional configuration here
      }
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    enabled = false,
    config = function()
      vim.cmd "colorscheme zenbones"
    end,
  },
  {
    "sam4llis/nvim-tundra",
    enabled = true,
    priority = 1000,
    lazy = false,
    config = function()
      local hl = require "utils.hl"
      local cp = require "nvim-tundra.palette.jungle"

      local get_hl = hl.get_hl

      require("nvim-tundra").setup {
        dim_inactive_windows = {
          enabled = true,
        },
        overwrite = {
          highlights = {
            StatusLineNC = { link = "LineNr" },
            NormalFloat = { fg = cp.marble._500, bg = cp.gray._1000 },
            -- NoicePopupmenu = { link = "FloatBorder" },
            CmpBorder = { link = "FloatBorder" },
            Pmenu = { link = "FloatBorder" },
            StatusLine = { fg = cp.marble._500, bg = cp.gray._1000 },

            TreesitterContext = { link = "NormalFloat" },

            MiniIconsAzure = { fg = cp.sapphire },
            MiniIconsBlue = { fg = cp.blue },
            MiniIconsCyan = { fg = cp.teal },
            MiniIconsGreen = { fg = cp.green },
            MiniIconsGrey = { fg = cp.text },
            MiniIconsOrange = { fg = cp.peach },
            MiniIconsPurple = { fg = cp.mauve },
            MiniIconsRed = { fg = cp.red },
            MiniIconsYellow = { fg = cp.yellow },
            --
            -- MiniStatuslineModeCommand = { fg = C.base, bg = C.peach, style = { "bold" } },
            MiniStatuslineModeInsert = { fg = "NONE", bg = cp.white, bold = true, reverse = true },
            MiniStatuslineModeNormal = { fg = cp.mantle, bg = cp.blue, style = { "bold" } },
            MiniStatuslineModeOther = { fg = cp.base, bg = cp.teal, style = { "bold" } },
            MiniStatuslineModeReplace = { fg = cp.base, bg = cp.red, style = { "bold" } },
            MiniStatuslineModeVisual = { fg = cp.base, bg = cp.mauve, style = { "bold" } },
            --
            -- MiniTrailspace = { bg = C.red },
          },
        },
        plugins = {
          lsp = true,
          semantic_tokens = true,
          treesitter = true,
          telescope = true,
          cmp = true,
          context = true,
          dbui = true,
          gitsigns = true,
          neogit = true,
          textfsm = true,
        },
      }
      vim.g.tundra_biome = "jungle" -- 'arctic' or 'jungle' or 'alpine'
      vim.opt.background = "dark"
      vim.cmd "colorscheme tundra"
    end,
  },
}
