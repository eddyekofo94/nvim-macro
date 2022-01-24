local get = require('utils/get')

return {
  'romgrk/barbar.nvim',
  event = 'BufNew',
  requries = get.spec('nvim-web-devicons'),
  config = get.config('barbar')
}
