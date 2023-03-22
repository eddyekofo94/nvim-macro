vim.api.nvim_create_augroup('LatexOpts', { clear = true })
vim.api.nvim_create_autocmd({
  'InsertEnter',
  'CursorMovedI',
  'TextChangedI',
}, {
  pattern = '*.tex',
  group = 'LatexOpts',
  callback = function()
    if vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
    then
      vim.bo.textwidth = 0
      return
    end
    vim.bo.textwidth = 79
  end,
})
