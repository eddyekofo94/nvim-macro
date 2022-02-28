local get = require('utils/get')

local spec = {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  requires = {
    get.spec('nvim-ts-rainbow'),
    get.spec('nvim-ts-context-commentstring'),
    get.spec('nvim-treesitter-textobjects')
  },
  config = get.config('nvim-treesitter')
}

return spec
