vim.api.nvim_create_autocmd('ModeChanged', {
  once = true,
  pattern = '*:[ictRss\x13]*',
  group = vim.api.nvim_create_augroup('IMInit', {}),
  callback = function()
    require('plugin.im').setup()
    return true
  end,
})
