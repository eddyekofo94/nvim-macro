local get= require('utils.get')

return {
  'folke/trouble.nvim',
  cmd = {
    'Trouble', 'TroubleToggle', 'TroubleRefresh',
    'XO', 'XR', 'XX', 'Xw', 'Xd', 'Xq', 'Xl', 'Xr'
  },
  requires = get.spec('nvim-web-devicons'),
  config = get.config('trouble')
}
