local get = require('utils/get')

return {
  'kyazdani42/nvim-tree.lua',
  cmd = {
    'NvimTreeClipboard', 'NvimTreeClose', 'NvimTreeFindFile',
    'NvimTreeFindFileToggle', 'NvimTreeFocus', 'NvimTreeOpen',
    'NvimTreeRefresh', 'NvimTreeResize', 'NvimTreeToggle',
    'TC', 'TQ', 'TFF', 'TFFT', 'TF', 'TO', 'TR', 'TS', 'TT'
  },
  requires = get.spec('nvim-web-devicons'),
  config = get.config('nvim-tree')
}
