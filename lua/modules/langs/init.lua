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

M['nvim-treesitter'] = {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  ft = ft_list,
  config = configs['nvim-treesitter'],
}

M['nvim-ts-rainbow'] = {
  'p00f/nvim-ts-rainbow',
  requires = 'nvim-treesitter',
  after = 'nvim-treesitter',
}

M['nvim-treesitter-textobjects'] = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  requires = 'nvim-treesitter',
  after = 'nvim-treesitter',
}

M['nvim-ts-context-commentstring'] = {
  'JoosepAlviste/nvim-ts-context-commentstring',
  requires = 'nvim-treesitter',
  after = 'nvim-treesitter',
}

M['lspsage.nvim'] = {
  'glepnir/lspsaga.nvim',
  enable = false,
  ft = ft_list,
  requires = 'nvim-lspconfig',
  after = 'nvim-lspconfig',
  config = configs['lspsaga.nvim'],
}

return M
