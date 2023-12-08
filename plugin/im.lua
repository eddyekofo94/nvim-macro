vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  group = vim.api.nvim_create_augroup('IMInit', {}),
  callback = function()
    require('plugin.im').setup()
    return true
  end,
})
