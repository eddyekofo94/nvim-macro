vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'markdown',
  command = 'let b:table_mode_corner = "|"',
})
