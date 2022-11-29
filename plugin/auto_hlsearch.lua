vim.keymap.set('n', '\\', '<cmd>set hlsearch!<CR>', { noremap = true })
vim.keymap.set('n', '/', '/<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '?', '?<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '*', '*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '#', '#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g*', 'g*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g#', 'g#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'n', 'n<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'N', 'N<cmd>set hlsearch<CR>', { noremap = true })

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  command = 'set nohlsearch'
})

