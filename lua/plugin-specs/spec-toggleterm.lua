return {
  'akinsho/toggleterm.nvim',
  keys = '<C-\\>',
  cmd = { 'ToggleTerm', 'ToggleTermToggleAdd', 'TermExec', 'Git',
          'ToggleTermFloat', 'ToggleTermHorizontal',
          'ToggleTermVertical', 'ToggleTermTab'},
  config = require('utils.get').config('toggleterm')
}

