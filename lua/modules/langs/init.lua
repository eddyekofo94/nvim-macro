local M = {}
local configs = require('modules.langs.configs')
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

M['aerial.nvim'] = {
  'stevearc/aerial.nvim',
  ft = 'markdown',
  requires = 'nvim-lspconfig',
  after = 'nvim-lspconfig',
  config = configs['aerial.nvim'],
}

M['nvim-navic'] = {
  'SmiteshP/nvim-navic',
  requires = { 'nvim-lspconfig', 'nvim-web-devicons' },
  after = 'nvim-lspconfig',
  config = configs['nvim-navic'],
}

M['fidget.nvim'] = {
  'j-hui/fidget.nvim',
  after = 'nvim-lspconfig',
  config = configs['fidget.nvim'],
}

return M
