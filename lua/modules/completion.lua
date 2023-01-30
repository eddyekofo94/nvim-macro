local configs = require('modules.completion.configs')

return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = configs['nvim-cmp'],
    dependencies = 'LuaSnip',
  },

  {
    'hrsh7th/cmp-calc',
    event = 'InsertEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-cmdline',
    event = 'CmdlineEnter',
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-nvim-lsp',
    module = false,
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
  },

  {
    'hrsh7th/cmp-nvim-lsp-signature-help',
    event = 'InsertEnter',
    dependencies = { 'nvim-cmp', 'nvim-lspconfig' },
  },

  {
    'hrsh7th/cmp-path',
    event = { 'CmdlineEnter', 'InsertEnter' },
    dependencies = 'nvim-cmp',
  },

  {
    'hrsh7th/cmp-buffer',
    event = { 'CmdlineEnter', 'InsertEnter' },
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
    config = configs['copilot.lua'],
  },

  {
    'L3MON4D3/LuaSnip',
    branch = 'get_jump_dest',
    event = 'InsertCharPre',
    config = configs['LuaSnip'],
  },
}
