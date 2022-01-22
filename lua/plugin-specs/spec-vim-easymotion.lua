return {
  'easymotion/vim-easymotion',
  keys = {
    ';f', ';of', ';s',
    ';os', ';l', ';ol',
    ';w', ';ow', '/', ';;'
  },
  config = require('utils/get').config('vim-easymotion')
}
