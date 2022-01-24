local get = require('utils/get')

return {
  'airblade/vim-gitgutter',
  event = 'BufWinEnter',
  config = get.config('vim-gitgutter'),
}
