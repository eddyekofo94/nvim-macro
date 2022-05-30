local get = require('utils.get')

return {
  'goolord/alpha-nvim',
  cmd = 'Alpha',
  requires = get.spec('nvim-web-devicons'),
  config = get.config('alpha-nvim')
}
