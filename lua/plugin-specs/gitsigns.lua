local get = require('utils.get')

return {
  'lewis6991/gitsigns.nvim',
  requires = {
    get.spec('plenary'),
    get.spec('vim-repeat')
  },
  config = get.config('gitsigns')
}
