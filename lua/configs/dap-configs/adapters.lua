return {
  python = {
    type = 'executable',
    command = 'python',
    args = { '-m', 'debugpy.adapter' },
  },
  bashdb = {
    type = 'executable',
    command = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/bash-debug-adapter',
    name = 'bashdb',
  },
}
