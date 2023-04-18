vim.keymap.set('n', '<Leader>gd', '<Cmd>Gdiff<CR>')
vim.keymap.set('n', '<Leader>gD', '<Cmd>Git diff<CR>')
vim.keymap.set('n', '<leader>gB', '<Cmd>Git blame<CR>')

vim.api.nvim_create_autocmd('User', {
  pattern = 'FugitiveIndex',
  group = vim.api.nvim_create_augroup('FugitiveSettings', {}),
  command = 'nmap <buffer> <Tab> = | xmap <buffer> <Tab> =',
})
