local null_ls = require('null-ls')

---Toggle format-on-save functionality for null-ls
---@param tbl table
local function null_ls_format_on_save(tbl)
  if tbl.args == '' or tbl.args == 'toggle' then
    vim.g.null_ls_format_on_save = not vim.g.null_ls_format_on_save
  elseif tbl.args == 'on' then
    vim.g.null_ls_format_on_save = true
  elseif tbl.args == 'off' then
    vim.g.null_ls_format_on_save = false
  end
  vim.notify(
    vim.g.null_ls_format_on_save and 'on' or 'off',
    vim.log.levels.INFO
  )
end

---Null-ls on-attach function
---@param client table LSP client
---@param bufnr integer buffer number
local function null_ls_on_attach(client, bufnr)
  if not client.supports_method('textDocument/formatting') then
    return
  end

  vim.api.nvim_create_augroup('NullLsFormatOnSave', { clear = false })
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    group = 'NullLsFormatOnSave',
    callback = function()
      if vim.g.null_ls_format_on_save then
        vim.lsp.buf.format({ bufnr = bufnr })
      end
    end,
  })

  vim.api.nvim_buf_create_user_command(
    bufnr,
    'NullLsFormatOnSave',
    null_ls_format_on_save,
    {
      nargs = '?',
      complete = function()
        return { 'on', 'off', 'toggle' }
      end,
      desc = 'Toggle Null-ls format-on-save functionality.',
    }
  )
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.latexindent,
    null_ls.builtins.formatting.shfmt,
  },
  on_attach = null_ls_on_attach,
})
