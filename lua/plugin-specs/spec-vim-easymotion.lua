return {
  'easymotion/vim-easymotion',
  keys = { '<Leader><Leader>' },
  cond = function () return (nil == vim.g.vscode) end,
  config = require('utils/get').config('vim-easymotion')
}
