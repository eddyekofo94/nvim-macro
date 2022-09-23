vim.keymap.set({ 'n', 't' }, '<C-\\><C-r>', '<cmd>RnvimrToggle<CR>', { noremap = true })
vim.keymap.set({ 'n', 't' }, '<C-\\>r', '<cmd>RnvimrToggle<CR>', { noremap = true })
vim.keymap.set({ 'n', 't' }, '<C-\\><C-s>', '<cmd>RnvimrResize<CR>', { noremap = true })
vim.keymap.set({ 'n', 't' }, '<C-\\>s', '<cmd>RnvimrResize<CR>', { noremap = true })

vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders both' }

vim.g.rnvimr_action = {
  ['<A-t>'] = 'NvimEdit tabedit',
  ['<A-s>'] = 'NvimEdit split',
  ['<A-v>'] = 'NvimEdit vsplit',
  ['gw'] = 'JumpNvimCwd',
  ['yw'] = 'EmitRangerCwd'
}
