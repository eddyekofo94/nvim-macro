local get = require('utils/get')

return {
  'kyazdani42/nvim-tree.lua',
  cmd = {
    'NvimTreeFindFile', 'NvimTreeFindFileToggle',
    'NvimTreeFocus', 'NvimTreeOpen', 'NvimTreeToggle',
  },
  keys = {
    '<Leader>tt', '<Leader>tff', '<Leader>tft', '<Leader>to'
  },
  requires = get.spec('nvim-web-devicons'),
  config = get.config('nvim-tree')
}
