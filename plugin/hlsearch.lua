-- automatically set and unset hlsearch

-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, 'n',  'n<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, 'N',  'N<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, '/',  '/<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, '?',  '?<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, 'g*', 'g*<Cmd>set hlsearch<CR>')
vim.keymap.set({ 'n', 'x' }, 'g#', 'g#<Cmd>set hlsearch<CR>')
vim.keymap.set('n', '*',  '*<Cmd>set hlsearch<CR>')
vim.keymap.set('n', '#',  '#<Cmd>set hlsearch<CR>')
vim.keymap.set('x', '*',  'y/\\V<C-R>=escape(@",\'/\')<CR><CR><Cmd>set hlsearch<CR>')
vim.keymap.set('x', '#',  'y?\\V<C-R>=escape(@",\'/\')<CR><CR><Cmd>set hlsearch<CR>')
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
