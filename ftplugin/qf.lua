vim.bo.buflisted = false
vim.wo.nu        = false
vim.wo.rnu       = false

vim.keymap.set('n', '<Tab>', '<CR><C-w>p',  { buffer = true })
vim.keymap.set('n', '<C-j>', 'j<CR><C-w>p', { buffer = true })
vim.keymap.set('n', '<C-k>', 'k<CR><C-w>p', { buffer = true })
vim.keymap.set('n', '}',     'j<CR><C-w>p', { buffer = true })
vim.keymap.set('n', '{',     'k<CR><C-w>p', { buffer = true })
