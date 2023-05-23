vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  once = true,
  group = vim.api.nvim_create_augroup('WinBarSetup', {}),
  callback = function()
    local winbar = require('plugin.winbar')
    local api = require('plugin.winbar.api')
    winbar.setup()
    vim.keymap.set('n', '<Leader>;', api.pick)
    vim.keymap.set('n', '[C', api.goto_context_start)
    vim.keymap.set('n', ']C', api.select_next_context)
  end,
})
