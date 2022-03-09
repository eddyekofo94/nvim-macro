return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = require('utils.get').config('nvim-autopairs')
}
