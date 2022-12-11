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

M['symbols-outline'] = {
  'simrat39/symbols-outline.nvim',
  requires = 'nvim-lspconfig',
  after = 'nvim-lspconfig',
  config = configs['symbols-outline.nvim'],
}

M['nvim-navic'] = {
  'SmiteshP/nvim-navic',
  after = 'nvim-lspconfig',
  config = configs['nvim-navic'],
}

return M
