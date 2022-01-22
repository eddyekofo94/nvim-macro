return {
  'easymotion/vim-easymotion',
  keys = {
    '<Space>f', '<Space>of', '<Space>s', '<Space>os', '<Space>l',
    '<Space>ol', '<Space>w', '<Space>ow', '<Space>ow', '<Space>~',
    '<Space>h', '<Space>j', '<Space>k', '<Space>l', '/'
    },
  cond = function () return (nil == vim.g.vscode) end,
  config = require('utils/get').config('vim-easymotion')
}
