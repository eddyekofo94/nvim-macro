-- stylua: ignore start
vim.bo.buflisted  = false
vim.opt_local.nu  = false
vim.opt_local.rnu = false
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set('n', '<Tab>', '<CR>zz<C-w>p',  { buffer = true })
vim.keymap.set('n', '<C-j>', 'j<CR>zz<C-w>p', { buffer = true })
vim.keymap.set('n', '<C-k>', 'k<CR>zz<C-w>p', { buffer = true })
vim.keymap.set('n', '<C-n>', 'j<CR>zz<C-w>p', { buffer = true })
vim.keymap.set('n', '<C-p>', 'k<CR>zz<C-w>p', { buffer = true })
-- stylua: ignore end
