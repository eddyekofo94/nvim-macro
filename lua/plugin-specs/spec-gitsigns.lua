local get = require('utils/get')

return {
  'lewis6991/gitsigns.nvim',
  requires = {
    get.spec('plenary'),
    get.spec('vim-repeat')
  },
  event = 'BufWinEnter',
  config = get.config('gitsigns')
}
