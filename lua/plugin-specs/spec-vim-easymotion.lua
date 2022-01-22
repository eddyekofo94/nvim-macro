return {
  'easymotion/vim-easymotion',
  keys = { ';f', ';of', ';s', ';os', ';l', ';ol', ';w', ';ow', '/', ';;' },
  cond = function () return (nil == vim.g.vscode) end,
  config = require('utils/get').config('vim-easymotion')
}
