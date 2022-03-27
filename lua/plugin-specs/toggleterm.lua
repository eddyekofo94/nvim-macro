local get = require('utils.get')

return {
  'akinsho/toggleterm.nvim',
  keys = {
    '<C-\\>', '<leader><leader>v',
    '<leader>v', '<leader>V'
  },
  cmd = {
    'ToggleTerm', 'ToggleTermToggleAdd', 'TermExec',
    'ToggleTermHorizontal', 'ToggleTermVertical',
    'ToggleTermFloat', 'ToggleTermTab',
    'Git', 'Vifm', 'VifmCurrentFile'
  },
  config = get.config('toggleterm'),
  -- Plenary is required for integration with vifm and lazygit
  requires = get.spec('plenary')
}

