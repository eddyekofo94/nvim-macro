vim.api.nvim_create_augroup('MarkdownOpts', { clear = true })
vim.api.nvim_create_autocmd({
  'InsertEnter',
  'CursorMovedI',
  'TextChangedI',
}, {
  pattern = '*.md',
  group = 'MarkdownOpts',
  callback = function()
    local line = vim.api.nvim_get_current_line()
    if
      line:match('^%s*|') -- table
      or line:match('^#') -- heading
      or vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
    then
      vim.bo.textwidth = 0
      return
    end
    vim.bo.textwidth = 79
  end,
})
