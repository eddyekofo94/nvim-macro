return {
  'easymotion/vim-easymotion',
  cond = function () return (nil == vim.g.vscode) end,
  config = require('utils/get').config('vim-easymotion')
}
