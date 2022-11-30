local M = {}
local configs = require('modules.lsp.configs')
local ft_list = require('utils.static').langs:list('ft')

M['nvim-lspconfig'] = {
  'neovim/nvim-lspconfig',
  ft = ft_list,
  config = configs['nvim-lspconfig'],
}

M['mason.nvim'] = {
  'williamboman/mason.nvim',
  cmd = {
    'Mason',
    'MasonUninstall',
    'MasonLog',
    'MasonInstall',
    'MasonUninstallAll',
  },
  module = 'mason',
  config = configs['mason.nvim'],
}

M['mason-lspconfig'] = {
  'williamboman/mason-lspconfig.nvim',
  requires = { 'mason.nvim', 'nvim-lspconfig', },
  ft = ft_list,
  config = configs['mason-lspconfig.nvim'],
}

M['lspsaga.nvim'] = {
  'glepnir/lspsaga.nvim',
  ft = ft_list,
  requires = 'nvim-lspconfig',
  after = 'nvim-lspconfig',
  config = configs['lspsaga.nvim'],
}

return M
