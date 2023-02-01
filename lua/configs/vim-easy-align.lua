vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)', { noremap = false })
vim.keymap.set({ 'n', 'x' }, 'gA', '<Plug>(LiveEasyAlign)', { noremap = false })
vim.g.easy_align_delimiters = {
  ['\\'] = {
    pattern = [[\\\+]],
  },
  ['/'] = {
    pattern = [[//\+\|/\*\|\*/]],
    delimiter_align = 'c',
    ignore_groups = '!Comment',
  },
}
