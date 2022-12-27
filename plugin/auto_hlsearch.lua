-- automatically set and unset hlsearch
vim.on_key(function(char)
  if vim.fn.mode() == 'n' and
    vim.tbl_contains({ 'n', 'N', '*', '#', '?', '/' },
    vim.fn.keytrans(char)) then
      vim.opt.hlsearch = true
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  command = 'set nohlsearch'
})

