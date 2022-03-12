vim.g.undotree_SplitWidth = 30
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_WindowLayout = 3
vim.g.undotree_DiffpanelHeight = 16
vim.g.undotree_SetFocusWhenToggle = 1
vim.api.nvim_set_keymap('n', '<Leader>uu', '<cmd>UndotreeToggle<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>uo', '<cmd>UndotreeShow<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>uq', '<cmd>UndotreeHide<CR>', {noremap = true})
