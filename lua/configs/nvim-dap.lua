local dap = require('dap')
vim.keymap.set('n', '<F1>', dap.up, { noremap = true })
vim.keymap.set('n', '<F2>', dap.down, { noremap = true })
vim.keymap.set('n', '<F5>', dap.continue, { noremap = true })
vim.keymap.set('n', '<F6>', dap.pause, { noremap = true })
vim.keymap.set('n', '<F8>', dap.repl.open, { noremap = true })
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, { noremap = true })
vim.keymap.set('n', '<F10>', dap.step_over, { noremap = true })
vim.keymap.set('n', '<F11>', dap.step_into, { noremap = true })
vim.keymap.set('n', '<F17>', dap.terminate, { noremap = true })
vim.keymap.set('n', '<F23>', dap.step_out, { noremap = true })
vim.keymap.set('n', '<F41>', dap.restart, { noremap = true })
-- Use shift + <F9> to set breakpoint condition
vim.keymap.set('n', '<F21>', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { noremap = true })
-- Use control + shift + <F9> to set breakpoint log message
vim.keymap.set('n', '<F45>', function()
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end, { noremap = true })

vim.api.nvim_create_user_command(
  'DapClear',
  dap.clear_breakpoints,
  { desc = 'Clear all breakpoints' }
)

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Tea' })
vim.fn.sign_define(
  'DapBreakpointCondition',
  { text = '', texthl = 'Conditional' }
)
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'Skyblue' })
vim.fn.sign_define('DapStopped', { text = '→', texthl = 'yellow' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'Iron' })

dap.adapters = require('configs.dap-configs.adapters')
dap.configurations = require('configs.dap-configs.configurations')
