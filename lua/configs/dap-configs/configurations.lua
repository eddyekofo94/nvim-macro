return {
  python = {
    {
      type = 'python',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      pythonPath = function()
        local cwd = vim.fn.getcwd()
        local fpath = vim.fn.expand('%:p:h')
        local paths = {
          fpath .. '/venv/bin/python',
          fpath .. '/.venv/bin/python',
          cwd .. '/venv/bin/python',
          cwd .. '/.venv/bin/python',
          '/usr/bin/python',
        }
        for _, path in ipairs(paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
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
