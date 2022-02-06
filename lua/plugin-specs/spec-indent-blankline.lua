local get = require('utils/get')

return {
  'lukas-reineke/indent-blankline.nvim',
  requires = {
    get.spec('nvim-treesitter'),    -- To identify functions, methods, etc
    get.spec('vim-sleuth')          -- To automatically detect indentation
 },
  config = get.config('indent-blankline')
}
