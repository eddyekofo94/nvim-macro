if not vim.b.midfile then
  vim.treesitter.start(0, 'markdown')
  vim.bo.syntax = 'on'
end
