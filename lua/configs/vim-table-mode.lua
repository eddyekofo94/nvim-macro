vim.api.nvim_create_augroup('TableModSetMarkdownCorner', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'markdown',
  group = 'TableModSetMarkdownCorner',
  command = 'let b:table_mode_corner = "|"',
})
