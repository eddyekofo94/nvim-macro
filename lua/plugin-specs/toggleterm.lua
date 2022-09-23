return {
  'akinsho/toggleterm.nvim',
  keys = { '<C-\\><C-\\>', '<C-\\>g', '<C-\\><C-g>' },
  cmd = {
    'ToggleTerm', 'ToggleTermToggleAdd',
    'TermExec', 'ToggleTermSendCurrentLine',
    'ToggleTermSendVisualLines', 'ToggleTermSendVisualSelection',
    'ToggleTermToggleAll', 'Git'
  },
  config = function() require('plugin-configs.toggleterm') end,
  -- Plenary is required for integration with lazygit
  requires = require('plugin-specs.plenary')
}
