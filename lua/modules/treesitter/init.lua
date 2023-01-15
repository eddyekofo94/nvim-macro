local M = {}
local configs = require('modules.treesitter.configs')
local ft_list = require('utils.static').langs:list('ft')

M['nvim-treesitter'] = {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  ft = ft_list,
  config = configs['nvim-treesitter'],
}

M['nvim-ts-rainbow'] = {
  'mrjones2014/nvim-ts-rainbow',
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

M['ts-node-action'] = {
  'CKolkey/ts-node-action',
  ft = ft_list,
  requires = 'nvim-treesitter',
  after = 'nvim-treesitter',
  config = configs['ts-node-action'],
}

return M
