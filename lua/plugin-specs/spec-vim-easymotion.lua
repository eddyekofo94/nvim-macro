return {
  'easymotion/vim-easymotion',
  event = 'VimEnter',
  cond = function () return (nil == vim.g.vscode) end,
  config = require('utils/get').config('vim-easymotion')
}
