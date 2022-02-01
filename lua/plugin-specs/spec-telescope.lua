local get = require('utils/get')

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {'<Leader>ff', '<Leader>fg', '<Leader>fb', '<Leader>fh'},
  requires = {
    get.spec('plenary'),
    get.spec('telescope-fzf-native'),
    get.spec('nvim-treesitter'),
    get.spec('nvim-web-devicons')
  },
  config = get.config('telescope')
}
