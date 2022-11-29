local M = {}
local configs = require('modules.completion.configs')

M['nvim-cmp'] = {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  module = 'cmp',
  config = configs['nvim-cmp'],
  requires = 'LuaSnip',
}

M['cmp-calc'] = {
  'hrsh7th/cmp-calc',
  requires = 'nvim-cmp',
  after = 'nvim-cmp',
}

M['cmp-cmdline'] = {
  'hrsh7th/cmp-cmdline',
  requires = 'nvim-cmp',
  after = 'nvim-cmp',
}

M['cmp-nvim-lsp'] = {
  'hrsh7th/cmp-nvim-lsp',
  requires = { 'nvim-cmp', 'nvim-lspconfig' },
  after = 'nvim-lspconfig',
}

M['cmp-path'] = {
  'hrsh7th/cmp-path',
  requires = 'nvim-cmp',
  after = 'nvim-cmp',
}

M['cmp-buffer'] = {
  'hrsh7th/cmp-buffer',
  requires = 'nvim-cmp',
  after = 'nvim-cmp',
}

M['cmp_luasnip'] = {
  'saadparwaiz1/cmp_luasnip',
  requires = { 'nvim-cmp', 'LuaSnip' },
  after = 'LuaSnip',
}

M['copilot-cmp'] = {
  'zbirenbaum/copilot-cmp',
  after = 'copilot.lua',
  requires ={ 'nvim-cmp', 'copilot.lua' },
  config = configs['copilot-cmp'],
}

M['copilot.lua'] = {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = configs['copilot.lua'],
}

M['LuaSnip'] = {
  'L3MON4D3/LuaSnip',
  event = 'InsertCharPre',
  module = 'luasnip',
  config = configs['LuaSnip'],
}

M['friendly-snippets'] = {
  'rafamadriz/friendly-snippets',
  requires = 'LuaSnip',
  after = 'LuaSnip',
  config = configs['friendly-snippets'],
}

M['nvim-autopairs'] = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = configs['nvim-autopairs']
}

return M
