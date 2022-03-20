local get = require('utils.get')
return {
  'nvim-lualine/lualine.nvim',
  requires = get.spec('nvim-web-devicons'),
  config = get.config('lualine')
}
