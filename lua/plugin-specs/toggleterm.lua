return {
  'akinsho/toggleterm.nvim',
  keys = {
    '<C-\\>', '<C-\\><C-v>', '<C-\\>v',
    '<C-\\>V', '<C-\\><C-V', '<C-\\>g', '<C-\\><C-g>'
  },
  cmd = {
    'ToggleTerm', 'ToggleTermToggleAdd',
    'TermExec', 'ToggleTermSendCurrentLine',
    'ToggleTermSendVisualLines', 'ToggleTermSendVisualSelection',
    'Git', 'Vifm', 'VifmCurrentFile', 'ToggleTermToggleAll',
  },
  config = function() require('plugin-configs.toggleterm') end,
  -- Plenary is required for integration with vifm and lazygit
  requires = require('plugin-specs.plenary')
}

