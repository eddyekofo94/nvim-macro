local get = require('utils.get')

return {
  'lewis6991/gitsigns.nvim',
  evnet = 'BufAdd',
  requires = {
    get.spec('plenary'),
    get.spec('vim-repeat')
  },
  config = get.config('gitsigns')
}
