local map = vim.api.nvim_set_keymap

vim.g.gitgutter_max_signs = 512
local opts = {}
map('n', ']h', '<Plug>(GitGutterNextHunk)', opts)
map('n', '[h', '<Plug>(GitGutterPrevHunk)', opts)
map('n', 'ggs', '<Plug>(GitGutterStageHunk)', opts)
map('n', 'ggu', '<Plug>(GitGutterUndoHunk)', opts)
map('n', 'ggv', '<Plug>(GitGutterPreviewHunk)', opts)
-- Text obj in hunk
map('o', 'ih', '<Plug>(GitGutterTextObjectInnerPending)', opts)
map('x', 'ih', '<Plug>(GitGutterTextObjectInnerVisual', opts)
-- Text obj around hunk
map('o', 'ah', '<Plug>(GitGutterTextObjectOuterPending)', opts)
map('x', 'ah', '<Plug>(GitGutterTextObjectOuterPending)', opts)
