local get = require('utils/get')

return {
  'nvim-telescope/telescope.nvim',
  requires = {
    get.spec('plenary'),
    get.spec('telescope-fzf-native'),
    get.spec('nvim-treesitter'),
    get.spec('nvim-web-devicons')
  },

}
