return {
  'tpope/vim-commentary',
  event = 'BufEnter',
  requires = require('utils/get').spec('vim-repeat')
}
