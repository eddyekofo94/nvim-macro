vim.g.undotree_SplitWidth = 40
vim.g.undotree_WindowLayout = 3
vim.api.nvim_set_keymap('n', '<Leader>uu', '<cmd>UndotreeToggle | UndotreeFocus<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>uo', '<cmd>UndotreeShow | UndotreeFocus<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>uq', '<cmd>UndotreeHide<CR>', {noremap = true})
