local map = vim.api.nvim_set_keymap

-- Ensure that the git signs will not be covered by multiple LSP diagnostics
vim.g.gitgutter_sign_allow_clobber = 1

vim.g.gitgutter_max_signs = 512
local opts = {}
map('n', ']h', '<Plug>(GitGutterNextHunk)', opts)
map('n', '[h', '<Plug>(GitGutterPrevHunk)', opts)
map('n', '<Leader>gs', '<Plug>(GitGutterStageHunk)', opts)
map('n', '<Leader>gu', '<Plug>(GitGutterUndoHunk)', opts)
map('n', '<Leader>gv', '<Plug>(GitGutterPreviewHunk)', opts)
-- Text obj in hunk
map('o', 'ih', '<Plug>(GitGutterTextObjectInnerPending)', opts)
map('x', 'ih', '<Plug>(GitGutterTextObjectInnerVisual', opts)
-- Text obj around hunk
map('o', 'ah', '<Plug>(GitGutterTextObjectOuterPending)', opts)
map('x', 'ah', '<Plug>(GitGutterTextObjectOuterPending)', opts)
