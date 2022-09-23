return {
  'nvim-telescope/telescope.nvim',
  opt = true,
  cmd = 'Telescope',
  keys = {
    '<Leader>F', '<Leader>ff', '<Leader>fo', '<Leader>f;',
    '<Leader>f*', '<Leader>fh', '<Leader>fm', '<Leader>fq',
    '<Leader>fl', '<Leader>fb', '<Leader>fR', '<Leader>fa',
    '<Leader>fe', '<Leader>fd', '<Leader>ft', '<Leader>fi',
    '<Leader>fp', '<Leader>fs', '<Leader>fS', '<Leader>fg',
    '<Leader>fj'
  },
  requires = {
    require('plugin-specs.plenary'),
    require('plugin-specs.telescope-fzf-native'),
    require('plugin-specs.telescope-project'),
    require('plugin-specs.nvim-web-devicons')
  },
  config = function() require('plugin-configs.telescope') end
}
