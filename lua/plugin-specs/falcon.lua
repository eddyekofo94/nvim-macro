return {
  'Bekaboo/falcon',
  cond = function()
    return vim.g.colorscheme == 'falcon'
  end,
  config = require('utils.get').config('falcon')
}
