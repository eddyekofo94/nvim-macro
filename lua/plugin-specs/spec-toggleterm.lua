return {
  'akinsho/toggleterm.nvim',
  keys = '<C-\\>',
  cmd = { 'ToggleTerm', 'ToggleTermToggleAdd', 'TermExec', 'Git'},
  config = require('utils/get').config('toggleterm')
}
