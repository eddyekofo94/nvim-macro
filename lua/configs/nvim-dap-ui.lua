local dap, dapui = require('dap'), require('dapui')
local static = require('utils.static')

-- stylua: ignore start
dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config']     = dapui.close
-- stylua: ignore end

-- Use menu key (Fn + left Ctrl) to open floating window
vim.keymap.set('n', '<F16>', dapui.float_element)
-- Use shift + F12 to evaluate expression
vim.keymap.set({ 'n', 'x' }, '<F24>', dapui.eval)

dapui.setup({
  layouts = {
    {
      elements = {
        { id = 'scopes', size = 0.25 },
        { id = 'breakpoints', size = 0.25 },
        { id = 'stacks', size = 0.25 },
        { id = 'watches', size = 0.25 },
      },
      position = 'left',
      size = 0.3,
    },
    {
      elements = {
        { id = 'repl', size = 0.5 },
        { id = 'console', size = 0.5 },
      },
      position = 'bottom',
      size = 0.25,
    },
  },
  icons = {
    expanded = vim.trim(static.icons.TriangleDown),
    collapsed = vim.trim(static.icons.TriangleRight),
    current_frame = vim.trim(static.icons.StackFrameCurrent),
  },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { '<CR>', '<Tab>', 'za' },
    open = { 'o', 'zo' },
    remove = { 'dd', 'x' },
    edit = { 's', 'cc' },
    repl = 'r',
    toggle = '<Leader><Leader>',
  },
  floating = {
    border = 'solid',
    max_height = 20,
    max_width = 80,
    mappings = {
      close = { 'q', '<Esc>' },
    },
  },
  windows = { indent = 1 },
})
