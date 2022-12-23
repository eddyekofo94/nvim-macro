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

M['cmp-nvim-lsp-signature-help'] = {
  'hrsh7th/cmp-nvim-lsp-signature-help',
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

return M
