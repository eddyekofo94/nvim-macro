local null_ls = require('null-ls')

vim.g.null_ls_format_on_save = false

vim.api.nvim_create_user_command('NullLsFormatOnSaveToggle', function()
  vim.g.null_ls_format_on_save = not vim.g.null_ls_format_on_save
end, { desc = 'Toggle Null-LS format-on-save functionality' })

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.shfmt,
  },
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          if vim.g.null_ls_format_on_save then
            vim.lsp.buf.format({ bufnr = bufnr })
          end
        end,
      })
    end
  end,
})
