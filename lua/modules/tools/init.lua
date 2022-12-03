local M = {}
local configs = require('modules/tools/configs')

M['telescope.nvim'] = {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    '<Leader>F', '<Leader>ff', '<Leader>fo', '<Leader>f;',
    '<Leader>f*', '<Leader>fh', '<Leader>fm', '<Leader>fb',
    '<Leader>fR', '<Leader>fa', '<Leader>fe', '<Leader>fp',
    '<Leader>fs', '<Leader>fS', '<Leader>fg', '<Leader>fm'
  },
  requires = {
    'plenary.nvim',
    'telescope-fzf-native.nvim'
  },
  config = configs['telescope.nvim'],
}

M['telescope-fzf-native.nvim'] = {
  'nvim-telescope/telescope-fzf-native.nvim',
  -- If it complains 'fzf doesn't exists, run 'make' inside
  -- the root folder of this plugin
  run = 'make',
  module = 'telescope._extensions.fzf',
  requires = 'telescope.nvim',
}

M['undotree'] = {
  'mbbill/undotree',
  keys = {
    '<Leader>uu',
    '<Leader>uo',
  },
  config = configs['undotree'],
}

M['vim-floaterm'] = {
  'voldikss/vim-floaterm',
  keys = { '<C-\\>', '<M-i>' },
  cmd = {
    'T',
    'ToggleTool',
    'FloatermNew',
    'FloatermToggle'
  },
  config = configs['vim-floaterm'],
}

M['gitsigns.nvim'] = {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  requires = 'plenary.nvim',
  config = configs['gitsigns.nvim'],
}

M['rnvimr'] = {
  'kevinhwang91/rnvimr',
  config = configs['rnvimr'],
}

return M
