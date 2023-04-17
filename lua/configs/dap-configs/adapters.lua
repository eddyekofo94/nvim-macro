local adapters = {}

adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

adapters.bashdb = {
  type = 'executable',
  command = vim.fn.stdpath('data')
    .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
  name = 'bashdb',
}

adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = vim.fn.stdpath('data')
      .. '/mason/packages/codelldb/extension/adapter/codelldb',
    args = { '--port', '${port}' },
  },
}

return adapters
