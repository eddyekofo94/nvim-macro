-- automatically set and unset hlsearch
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    vim.opt.hlsearch = vim.tbl_contains({
      'n', 'N', '*', '#', '?', '/'
    }, vim.fn.keytrans(char))
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))

vim.keymap.set('n', '\\', '<Cmd>set hlsearch!<CR>', { noremap = true })

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  command = 'set nohlsearch'
})
