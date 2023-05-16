if not vim.env.NVIM_MANPAGER then
  return
end

vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = 'no'
vim.opt.scrolloff = 999
vim.opt.laststatus = 0

vim.keymap.set({ 'n', 'x' }, 'q', 'ZQ')
vim.keymap.set({ 'n', 'x' }, 'd', '<C-d>')
vim.keymap.set({ 'n', 'x' }, 'u', '<C-u>')
