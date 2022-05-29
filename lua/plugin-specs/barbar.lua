local get = require('utils.get')

return {
  'romgrk/barbar.nvim',
  event = 'BufAdd',
  requries = get.spec('nvim-web-devicons'),
  config = get.config('barbar')
}
