vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('TermInit', {}),
  callback = function(info)
    require('plugin.term').setup(info.buf)
  end,
})
