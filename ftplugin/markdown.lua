vim.api.nvim_buf_set_keymap(0, 'n', '<C-p>',
  '<cmd>MarkdownPreview<CR>', { noremap = true, silent = true })

vim.api.nvim_buf_create_user_command(
  0, 'MarkdownToPDF', function ()
    vim.cmd('write')
    vim.cmd('silent !md2pdf %')
    vim.cmd('silent !okular %:r.pdf &')
  end,
  { desc = 'Convert markdown to pdf' }
)
