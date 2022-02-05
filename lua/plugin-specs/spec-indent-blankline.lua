local get = require('utils/get')

return {
  'lukas-reineke/indent-blankline.nvim',
  requires = get.spec('nvim-treesitter'),
  config = get.config('indent-blankline')
}
