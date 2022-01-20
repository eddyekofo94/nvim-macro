local get = require('utils/get')

local spec = {
  get.spec('nvim-ts-rainbow'),
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    after = 'nvim-ts-rainbow',
    config = get.config('nvim-treesitter')
  }
}

return spec
