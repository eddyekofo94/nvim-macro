vim.keymap.set({ 'n', 'x', 'x' }, '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Multi-window operations
vim.keymap.set({ 'n', 't' }, '<M-W>',      '<C-\\><C-n><C-w>W')
vim.keymap.set({ 'n', 't' }, '<M-H>',      '<C-\\><C-n><C-w>H')
vim.keymap.set({ 'n', 't' }, '<M-J>',      '<C-\\><C-n><C-w>J')
vim.keymap.set({ 'n', 't' }, '<M-K>',      '<C-\\><C-n><C-w>K')
vim.keymap.set({ 'n', 't' }, '<M-L>',      '<C-\\><C-n><C-w>L')
vim.keymap.set({ 'n', 't' }, '<M-=>',      '<C-\\><C-n><C-w>=')
vim.keymap.set({ 'n', 't' }, '<M-->',      '<C-\\><C-n><C-w>-')
vim.keymap.set({ 'n', 't' }, '<M-+>',      '<C-\\><C-n><C-w>+')
vim.keymap.set({ 'n', 't' }, '<M-_>',      '<C-\\><C-n><C-w>_')
vim.keymap.set({ 'n', 't' }, '<M-|>',      '<C-\\><C-n><C-w>|')
vim.keymap.set({ 'n', 't' }, '<M-<>',      '<C-\\><C-n><C-w><')
vim.keymap.set({ 'n', 't' }, '<M->>',      '<C-\\><C-n><C-w>>')
vim.keymap.set({ 'n', 't' }, '<M-p>',      '<C-\\><C-n><C-w>p')
vim.keymap.set({ 'n', 't' }, '<M-r>',      '<C-\\><C-n><C-w>r')
vim.keymap.set({ 'n', 't' }, '<M-v>',      '<C-\\><C-n><C-w>v')
vim.keymap.set({ 'n', 't' }, '<M-s>',      '<C-\\><C-n><C-w>s')
vim.keymap.set({ 'n', 't' }, '<M-x>',      '<C-\\><C-n><C-w>x')
vim.keymap.set({ 'n', 't' }, '<M-z>',      '<C-\\><C-n><C-w>z')
vim.keymap.set({ 'n', 't' }, '<M-c>',      '<C-\\><C-n><C-w>c')
vim.keymap.set({ 'n', 't' }, '<M-n>',      '<C-\\><C-n><C-w>n')
vim.keymap.set({ 'n', 't' }, '<M-o>',      '<C-\\><C-n><C-w>o')
vim.keymap.set({ 'n', 't' }, '<M-t>',      '<C-\\><C-n><C-w>t')
vim.keymap.set({ 'n', 't' }, '<M-T>',      '<C-\\><C-n><C-w>T')
vim.keymap.set({ 'n', 't' }, '<M-]>',      '<C-\\><C-n><C-w>]')
vim.keymap.set({ 'n', 't' }, '<M-^>',      '<C-\\><C-n><C-w>^')
vim.keymap.set({ 'n', 't' }, '<M-b>',      '<C-\\><C-n><C-w>b')
vim.keymap.set({ 'n', 't' }, '<M-d>',      '<C-\\><C-n><C-w>d')
vim.keymap.set({ 'n', 't' }, '<M-f>',      '<C-\\><C-n><C-w>f')
vim.keymap.set({ 'n', 't' }, '<M-}>',      '<C-\\><C-n><C-w>}')
vim.keymap.set({ 'n', 't' }, '<M-g>]',     '<C-\\><C-n><C-w>g]')
vim.keymap.set({ 'n', 't' }, '<M-g>}',     '<C-\\><C-n><C-w>g}')
vim.keymap.set({ 'n', 't' }, '<M-g>f',     '<C-\\><C-n><C-w>gf')
vim.keymap.set({ 'n', 't' }, '<M-g>F',     '<C-\\><C-n><C-w>gF')
vim.keymap.set({ 'n', 't' }, '<M-g>t',     '<C-\\><C-n><C-w>gt')
vim.keymap.set({ 'n', 't' }, '<M-g>T',     '<C-\\><C-n><C-w>gT')
vim.keymap.set({ 'n', 't' }, '<M-w>',      '<C-\\><C-n><C-w><C-w>')
vim.keymap.set({ 'n', 't' }, '<M-h>',      '<C-\\><C-n><C-w><C-h>')
vim.keymap.set({ 'n', 't' }, '<M-j>',      '<C-\\><C-n><C-w><C-j>')
vim.keymap.set({ 'n', 't' }, '<M-k>',      '<C-\\><C-n><C-w><C-k>')
vim.keymap.set({ 'n', 't' }, '<M-l>',      '<C-\\><C-n><C-w><C-l>')
vim.keymap.set({ 'n', 't' }, '<M-g><M-]>', '<C-\\><C-n><C-w>g<C-]>')
vim.keymap.set({ 'n', 't' }, '<M-g><Tab>', '<C-\\><C-n><C-w>g<Tab>')

-- Up/down motions
vim.keymap.set('n', 'j', 'v:count ? "j" : "gj"', { expr = true })
vim.keymap.set('n', 'k', 'v:count ? "k" : "gk"', { expr = true })

-- Buffer navigation
vim.keymap.set('n', '<Tab>', '<Cmd>bn<CR>')
vim.keymap.set('n', '<S-Tab>', '<Cmd>bp<CR>')
vim.keymap.set('n', '<C-n>', '<C-i>')

-- Correct misspelled word / mark as correct
vim.keymap.set('i', '<C-S-L>', '<Esc>[szg`]a')
vim.keymap.set('i', '<C-l>', '<C-G>u<Esc>[s1z=`]a<C-G>u')

-- Close all floating windows
vim.keymap.set('n', 'q', function()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    -- close floating windows that can be focused
    if config.relative ~= '' and config.focusable then
      vim.api.nvim_win_close(win, false) -- do not force
      count = count + 1
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('q', true, true, true),
      'n',
      false
    )
  end
end)

---Toggle between light and dark background, set global variables accordingly
vim.keymap.set('n', '<M-D>', function()
  if vim.o.background == 'dark' then
    vim.opt.background = 'light'
    vim.opt.background = 'light' -- Flash cached dev icons
    vim.g.BACKGROUND = 'light'
  else
    vim.opt.background = 'dark'
    vim.opt.background = 'dark' -- Flash cached dev icons
    vim.g.BACKGROUND = 'dark'
  end
end)

-- Text object: current buffer
vim.keymap.set('x', 'af', ':<C-u>keepjumps silent! normal! ggVG<CR>')
vim.keymap.set('x', 'if', ':<C-u>keepjumps silent! normal! ggVG<CR>')
vim.keymap.set('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { noremap = false })
vim.keymap.set('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { noremap = false })
