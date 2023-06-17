return {
  {
    'hrsh7th/nvim-cmp',
    lazy = true,
    config = function()
      require('configs.nvim-cmp')
    end,
    dependencies = 'LuaSnip',
  },

  {
    'hrsh7th/cmp-calc',
    event = 'InsertEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-cmdline',
    pin = true,
    build = 'git apply '
      .. vim.fn.stdpath('config')
      .. '/patches/cmp-cmdline.patch',
    event = 'CmdlineEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-nvim-lsp',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
  },

  {
    'hrsh7th/cmp-nvim-lsp-signature-help',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
  },

  {
    'tzachar/fuzzy.nvim',
    lazy = true,
  },

  {
    'tzachar/cmp-fuzzy-path',
    pin = true,
    build = 'git apply '
      .. vim.fn.stdpath('config')
      .. '/patches/cmp-fuzzy-path.patch',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = { 'fuzzy.nvim', 'nvim-cmp' },
  },

  {
    'tzachar/cmp-fuzzy-buffer',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = { 'fuzzy.nvim', 'nvim-cmp' },
  },

  {
    'rcarriga/cmp-dap',
    event = 'InsertEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'saadparwaiz1/cmp_luasnip',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'LuaSnip' },
  },

  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('configs.copilot')
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function()
      require('configs.LuaSnip')
    end,
  },
}
