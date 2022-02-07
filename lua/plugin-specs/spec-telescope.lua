local get = require('utils/get')

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  keys = {
    '<Leader>ff', '<Leader>fg', '<Leader>fw', '<Leader>fh',
    '<Leader>fm', '<Leader>fq', '<Leader>fll', '<Leader>fT',
    '<Leader>fbl', '<Leader>fbf', '<Leader>fbT', '<Leader>fr',
    '<Leader>fc', '<Leader>fe', '<Leader>fd', '<Leader>ft',
    '<Leader>fi', '<Leader>fp'
  },
  requires = {
    get.spec('plenary'),
    get.spec('telescope-fzf-native'),
    get.spec('nvim-treesitter'),
    get.spec('nvim-web-devicons')
  },
  config = get.config('telescope')
}
