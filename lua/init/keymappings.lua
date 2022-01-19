-------------------------------------------------------------------------------
-- KEYMAPPINGS ----------------------------------------------------------------
-------------------------------------------------------------------------------
-- NOTICE: Not all keymappings are kept in this file
-- Only general keymappings are kept here
-- Plugin-specific keymappings are kept in corresponding
-- config files for that plugin

local map = vim.api.nvim_set_keymap
local g = vim.g

-- Map leader key to space
map('n', '<Space>', '', {})
g.mapleader = ' '

-- Map esc key
map('i', 'jj', '<esc>', {noremap = true})

-- Exit from term mode
map('t', '<esc>', '<C-\\><C-n>', {noremap = true})

-- Yank/delete/change all
map('n', 'yA', 'ggyG', {noremap = true})
map('n', 'dA', 'ggdG', {noremap = true})
map('n', 'cA', 'ggcG', {noremap = true})
-- Visual select all
map('v', 'A', '<esc>ggvG', {noremap = true})

-- Multi-window operations
map('n', '<M-w>', '<C-w><C-w>', {noremap = true})
map('n', '<M-h>', '<C-w><C-h>', {noremap = true})
map('n', '<M-j>', '<C-w><C-j>', {noremap = true})
map('n', '<M-k>', '<C-w><C-k>', {noremap = true})
map('n', '<M-l>', '<C-w><C-l>', {noremap = true})
map('n', '<M-=>', '<C-w>=', {noremap = true})
map('n', '<M-->', '<C-w>-', {noremap = true})
map('n', '<M-+>', '<C-w>+', {noremap = true})
map('n', '<M-_>', '<C-w>_', {noremap = true})
map('n', '<M-|>', '<C-w>|', {noremap = true})
map('n', '<M-,>', '<C-w><', {noremap = true})
map('n', '<M-.>', '<C-w>>', {noremap = true})
map('n', '<M-v>', ':vsplit<CR>', {noremap = true, silent = true})
map('n', '<M-x>', ':split<CR>', {noremap = true, silent = true})
map('n', '<M-q>', '<C-w>c', {noremap = true})   -- Close current window
map('n', '<M-o>', '<C-w>o', {noremap = true})   -- Close all other windows

map('n', '<Tab>', ':bn<CR>', {noremap = true, silent = true})
map('n', '<S-Tab>', ':bp<CR>', {noremap = true, silent = true})
map('n', 'c<Tab>', ':bd<CR>', {noremap = true})

-- Moving in insert mode
map('i', '<M-h>', '<left>', {noremap = true})
map('i', '<M-j>', '<down>', {noremap = true})
map('i', '<M-k>', '<up>', {noremap = true})
map('i', '<M-l>', '<right>', {noremap = true})

-- Patch for pairing
local pair_available, _ = pcall(vim.cmd, [[source lua/utils/pair.vim]])
if not pair_available then print('[general]: pairing patch not available') end
