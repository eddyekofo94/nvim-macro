return {
  'ZSaberLv0/ZFVimIM',
  opt = true,
  keys = {
    { 'i', '<C-Space>' }, { 'c', '<C-Space>' },
    { 'v', '<C-Space>' }, { 'n', '<C-Space>' }
  },
  requires = {
    require('plugin-specs.ZFVimJob'),
    require('plugin-specs.ZFVimIM_openapi'),
  },
  setup = [[
    vim.g.ZFVimIM_keymap = 0
    vim.g.ZFVimIM_openapi_enable = 1
    vim.g.ZFVimIM_openapi_word_type = 'sentence'
  ]], -- Do not set default keymap
  config = function() require('plugin-configs.ZFVimIM') end
}
