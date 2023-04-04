return {
  python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
          return cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
          return cwd .. '/.venv/bin/python'
        else
          return '/usr/bin/python'
        end
      end,
    },
  },
  sh = {
    {
      type = 'bashdb',
      request = 'launch',
      name = 'Launch file',
      showDebugOutput = true,
      pathBashdb = vim.fn.stdpath('data')
        .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb',
      pathBashdbLib = vim.fn.stdpath('data')
        .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir',
      trace = true,
      file = '${file}',
      program = '${file}',
      cwd = '${workspaceFolder}',
      pathCat = 'cat',
      pathBash = '/bin/bash',
      pathMkfifo = 'mkfifo',
      pathPkill = 'pkill',
      args = {},
      env = {},
      terminalKind = 'integrated',
    },
  },
}
