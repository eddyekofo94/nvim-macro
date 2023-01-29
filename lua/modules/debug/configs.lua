local M = {}

M['nvim-dap'] = function()
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

  vim.api.nvim_create_user_command('DapClear', dap.clear_breakpoints,
    { desc = 'Clear all breakpoints' })

  vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Tea' })
  vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'Conditional' })
  vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'Skyblue' })
  vim.fn.sign_define('DapStopped', { text = '→', texthl = 'yellow' })
  vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'Iron' })

  dap.adapters = require('modules.debug.dap-configs.adapters')
  dap.configurations = require('modules.debug.dap-configs.configurations')
end

M['nvim-dap-ui'] = function()
  local dap, dapui = require('dap'), require('dapui')
  dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
  dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
  dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
  -- Use menu key (Fn + left Ctrl) to open floating window
  vim.keymap.set('n', '<F16>', dapui.float_element, { noremap = true })
  -- Use shift + F12 to evaluate expression
  vim.keymap.set({ 'n', 'x' }, '<F24>', dapui.eval, { noremap = true })
  dapui.setup({
    expand_lines = false,
    layouts = { {
        elements = { {
            id = 'scopes',
            size = 0.25
          }, {
            id = 'breakpoints',
            size = 0.25
          }, {
            id = 'stacks',
            size = 0.25
          }, {
            id = 'watches',
            size = 0.25
          } },
        position = 'left',
        size = 0.3
      }, {
        elements = { {
            id = 'repl',
            size = 0.5
          }, {
            id = 'console',
            size = 0.5
          } },
        position = 'bottom',
        size = 0.25
      } },
    icons = {
      expanded = '▼',
      collapsed = '►',
      current_frame = '►',
    },
    mappings = {
      -- Use a table to apply multiple mappings
      expand = { '<Tab>', '<LeftMouse>' },
      open = { '<CR>', 'o' },
      remove = { 'dd', 'x' },
      edit = { 's', 'cc' },
      repl = 'r',
      toggle = '<Leader><Leader>',
    },
    floating = {
      max_height = 20,
      max_width = 80,
      mappings = {
        close = { 'q', '<Esc>' },
      },
    },
    windows = { indent = 1 },
  })
end

M['mason-nvim-dap.nvim'] = function()
  local mason_nvim_dap = require('mason-nvim-dap')
  mason_nvim_dap.setup({
    ensure_installed = require('utils.static').langs:list('dap'),
    automatic_setup = true,
  })
  mason_nvim_dap.setup_handlers({
    python = function(_) end, -- suppress auto setup for python
  })
end

return M
