vim.api.nvim_create_augroup('SpycesInit', {})
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  group = 'SpycesInit',
  callback = function()
    require('plugin.spyces').init()
  end,
})
