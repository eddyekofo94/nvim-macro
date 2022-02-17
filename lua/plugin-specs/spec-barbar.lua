local get = require('utils/get')

return {
  'bekaboo/barbar.nvim',
  event = 'BufAdd',
  requries = get.spec('nvim-web-devicons'),
  config = get.config('barbar')
}
