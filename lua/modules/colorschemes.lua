return {
  {
    'rebelot/kanagawa.nvim',
  },
  {
    'frenzyexists/aquarium-vim',
    name = 'aquarium',
    config = function()
      -- vim.cmd[[colorscheme aquarium]]
    end,
  },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
  },

  {
    'sainnhe/everforest',
  },

  {
    'sainnhe/gruvbox-material',
  },
  -- {
  --   'catppuccin/nvim',
  --   name = 'catppuccin',
  --   build = ':CatppuccinCompile',
  --   priority = 1000,
  --   enabled = true,
  --   config = function()
  --     require('modules.catppuccin')
  --     vim.cmd([[colorscheme catppuccin]])
  --   end,
  -- },
}
