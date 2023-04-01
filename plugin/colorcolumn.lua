vim.api.nvim_create_augroup('AutoColorColumnInit', {})
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  once = true,
  group = 'AutoColorColumnInit',
  callback = function()
    require('plugin.colorcolumn').start()
  end,
})
