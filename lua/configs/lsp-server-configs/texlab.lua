local default_config = require('configs.lsp-server-configs.shared.default')

local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use an on_attach function to only map the following keys
  vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,                                                                { buffer = bufnr })
  vim.keymap.set('n', 'gD',         vim.lsp.buf.type_definition,                                                           { buffer = bufnr })
  vim.keymap.set('n', 'K',          vim.lsp.buf.hover,                                                                     { buffer = bufnr })
  vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder,                                                      { buffer = bufnr })
  vim.keymap.set('n', '<Leader>wd', vim.lsp.buf.remove_workspace_folder,                                                   { buffer = bufnr })
  vim.keymap.set('n', '<Leader>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end,                        { buffer = bufnr })
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action,                                                               { buffer = bufnr })
  vim.keymap.set('n', '<Leader>r',  vim.lsp.buf.rename,                                                                    { buffer = bufnr })
  vim.keymap.set('n', '<Leader>R',  vim.lsp.buf.references,                                                                { buffer = bufnr })
  vim.keymap.set('n', '<Leader>e',  vim.diagnostic.open_float,                                                             { buffer = bufnr })
  vim.keymap.set('n', '<leader>E',  vim.diagnostic.setloclist,                                                             { buffer = bufnr })
  vim.keymap.set('n', '[e',         vim.diagnostic.goto_prev,                                                              { buffer = bufnr })
  vim.keymap.set('n', ']e',         vim.diagnostic.goto_next,                                                              { buffer = bufnr })
  vim.keymap.set('n', '[E',         function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = bufnr })
  vim.keymap.set('n', ']E',         function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = bufnr })
  vim.keymap.set('n', '[W',         function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,  { buffer = bufnr })
  vim.keymap.set('n', ']W',         function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end,  { buffer = bufnr })

  -- integration with nvim-navic
  if client and client.server_capabilities
            and client.server_capabilities.documentSymbolProvider then
    local status, navic = pcall(require, 'nvim-navic')
    if status then
      navic.attach(client, bufnr)
    end
  end
end

return vim.tbl_deep_extend('force', default_config, {
  on_attach = on_attach,
  capabilities = {
    offsetEncoding = { 'utf-8' },
  },
})
