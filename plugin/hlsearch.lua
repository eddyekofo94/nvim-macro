-- automatically set and unset hlsearch

-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, 'n',  'n<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, 'N',  'N<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, '/',  '/<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, '?',  '?<Cmd>set hlsearch<CR>')
vim.keymap.set('n', '*',  '*<Cmd>set hlsearch<CR>')
vim.keymap.set('n', '#',  '#<Cmd>set hlsearch<CR>')
vim.keymap.set('n', 'g*', 'g*<Cmd>set hlsearch<CR>')
vim.keymap.set('n', 'g#', 'g#<Cmd>set hlsearch<CR>')
vim.keymap.set('x', '*',  'y/\\V\\<<C-R>=escape(@",\'/\')<CR>\\><CR><Cmd>set hlsearch<CR>')
vim.keymap.set('x', '#',  'y?\\V\\<<C-R>=escape(@",\'/\')<CR>\\><CR><Cmd>set hlsearch<CR>')
vim.keymap.set('x', 'g*', 'y/\\V<C-R>=escape(@",\'/\')<CR><CR><Cmd>set hlsearch<CR>')
vim.keymap.set('x', 'g#', 'y?\\V<C-R>=escape(@",\'/\')<CR><CR><Cmd>set hlsearch<CR>')
-- stylua: ignore end

vim.keymap.set({ 'n', 'x' }, '<C-l>', function()
  return vim.go.hlsearch and '<Cmd>set nohlsearch<CR>'
    or '<Cmd>set nohlsearch|diffupdate|normal! <C-l><CR>'
end, { expr = true })

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  group = vim.api.nvim_create_augroup('AutoHlSearch', {}),
  command = 'set nohlsearch',
})
