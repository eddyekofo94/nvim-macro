local adapters = {}

adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

adapters.bashdb = {
  type = 'executable',
  command = 'node',
  args = {
    vim.fn.stdpath('data') .. '/vscode-bash-debug/extension/out/bashDebug.js',
  },
  name = 'bashdb',
}

adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'codelldb',
    args = { '--port', '${port}' },
  },
}

return adapters
