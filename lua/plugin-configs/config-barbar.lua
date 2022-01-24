local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<S-Tab>', ':BufferPrevious<CR>', opts)
map('n', '<Tab>', ':BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<M-<>', ':BufferMovePrevious<CR>', opts)
map('n', '<M->>', ' :BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<M-1>', ':BufferGoto 1<CR>', opts)
map('n', '<M-2>', ':BufferGoto 2<CR>', opts)
map('n', '<M-3>', ':BufferGoto 3<CR>', opts)
map('n', '<M-4>', ':BufferGoto 4<CR>', opts)
map('n', '<M-5>', ':BufferGoto 5<CR>', opts)
map('n', '<M-6>', ':BufferGoto 6<CR>', opts)
map('n', '<M-7>', ':BufferGoto 7<CR>', opts)
map('n', '<M-8>', ':BufferGoto 8<CR>', opts)
map('n', '<M-9>', ':BufferGoto 9<CR>', opts)
map('n', '<M-0>', ':BufferLast<CR>', opts)
-- Delete buffer
map('n', '<M-d>', ':BufferClose<CR>', opts) -- Similar but better than `:bd`
-- Wipeout buffer
-- map('n', '???', ':BufferWipeout<CR>', opts)
-- Close commands
map('n', '<M-a>', ':BufferCloseAllButCurrent<CR>', opts)
-- map('n', '???', ':BufferCloseBuffersLeft<CR>', opts)
-- map('n', '???', ':BufferCloseBuffersRight<CR>', opts)
-- Magic buffer-picking mode
map('n', '<M-p>', ':BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Leader>bb', ':BufferOrderByBufferNumber<CR>', opts)
map('n', '<Leader>bd', ':BufferOrderByDirectory<CR>', opts)
map('n', '<Leader>bl', ':BufferOrderByLanguage<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
