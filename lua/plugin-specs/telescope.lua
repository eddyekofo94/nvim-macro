local get = require('utils.get')

return {
  'nvim-telescope/telescope.nvim',
  opt = true,
  cmd = 'Telescope',
  keys = {
    '<Leader>F', '<Leader>ff', '<Leader>fof', '<Leader>f;',
    '<Leader>f*', '<Leader>fh', '<Leader>fm', '<Leader>fq',
    '<Leader>fl', '<Leader>fbf', '<Leader>fR', '<Leader>fa',
    '<Leader>fe', '<Leader>fd', '<Leader>ftd', '<Leader>fi',
    '<Leader>fp', '<Leader>fs', '<Leader>fS', '<Leader>fg',
    '<Leader>fj'
  },
  requires = {
    get.spec('plenary'),
    get.spec('telescope-fzf-native'),
    get.spec('telescope-project'),
    get.spec('nvim-treesitter'),
    get.spec('nvim-web-devicons')
  },
  config = get.config('telescope')
}
