return {
  { "sainnhe/everforest" },
  { "sainnhe/gruvbox-material" },
  { "projekt0n/github-nvim-theme" },
  { "EdenEast/nightfox.nvim" },
  { "sainnhe/edge" },
  { import = "modules.colorschemes.catppuccin" },
  {
    "sam4llis/nvim-tundra",
    enabled = true,
    priority = 1000,
    config = function()
      require("nvim-tundra").setup {
        plugins = {
          telescope = true,
          cmp = true,
        },
      }
      vim.g.tundra_biome = "arctic" -- 'arctic' or 'jungle'
      vim.opt.background = "dark"
      vim.cmd "colorscheme tundra"
    end,
  },
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
    config = true,
  },
  {
    "Verf/deepwhite.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      -- vim.cmd [[colorscheme deepwhite]]
    end,
  },
  {
    "mcchrish/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    enabled = true,
    config = function()
      vim.cmd "colorscheme zenbones"
    end,
  },
}
