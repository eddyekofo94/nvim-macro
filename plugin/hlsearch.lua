-- automatically set and unset hlsearch

-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, 'n',  '<Cmd>set hlsearch<CR>n')
vim.keymap.set({ 'n', 'x' }, 'N',  '<Cmd>set hlsearch<CR>N')
vim.keymap.set({ 'n', 'x' }, '/',  '<Cmd>set hlsearch<CR>/')
vim.keymap.set({ 'n', 'x' }, '?',  '<Cmd>set hlsearch<CR>?')
vim.keymap.set({ 'n', 'x' }, '*',  '<Cmd>set hlsearch<CR>*')
vim.keymap.set({ 'n', 'x' }, '#',  '<Cmd>set hlsearch<CR>#')
vim.keymap.set({ 'n', 'x' }, 'g*', '<Cmd>set hlsearch<CR>g*')
vim.keymap.set({ 'n', 'x' }, 'g#', '<Cmd>set hlsearch<CR>g#')
-- stylua: ignore end

vim.keymap.set({ 'n', 'x' }, '<C-l>', function()
  if vim.go.hlsearch then
    vim.go.hlsearch = false
    return '<Ignore>'
  else
    return '<C-l>'
  end
end, { expr = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('AutoHlSearch', {}),
  command = 'set nohlsearch',
})
