local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Use an on_attach function to only map the following keys
  vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,                                                                { buffer = true })
  vim.keymap.set('n', 'gD',         vim.lsp.buf.type_definition,                                                           { buffer = true })
  vim.keymap.set('n', 'K',          vim.lsp.buf.hover,                                                                     { buffer = true })
  vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder,                                                      { buffer = true })
  vim.keymap.set('n', '<Leader>wd', vim.lsp.buf.remove_workspace_folder,                                                   { buffer = true })
  vim.keymap.set('n', '<Leader>wl', function() vim.print(vim.lsp.buf.list_workspace_folders()) end,                        { buffer = true })
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action,                                                               { buffer = true })
  vim.keymap.set('n', '<Leader>r',  vim.lsp.buf.rename,                                                                    { buffer = true })
  vim.keymap.set('n', '<Leader>R',  vim.lsp.buf.references,                                                                { buffer = true })
  vim.keymap.set('n', '<Leader>e',  vim.diagnostic.open_float,                                                             { buffer = true })
  vim.keymap.set('n', '<leader>E',  vim.diagnostic.setloclist,                                                             { buffer = true })
  vim.keymap.set('n', '[e',         vim.diagnostic.goto_prev,                                                              { buffer = true })
  vim.keymap.set('n', ']e',         vim.diagnostic.goto_next,                                                              { buffer = true })
  vim.keymap.set('n', '[E',         function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = true })
  vim.keymap.set('n', ']E',         function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = true })
  vim.keymap.set('n', '[W',         function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,  { buffer = true })
  vim.keymap.set('n', ']W',         function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end,  { buffer = true })
  vim.keymap.set('x', '=',          vim.lsp.buf.format)
  vim.keymap.set('n', '=', function()
    if not client.supports_method('textDocument/formatting') then
      return '='
    end
    function LspFormatMotion(_)
      vim.lsp.buf.format({
        range = {
          ['start'] = vim.api.nvim_buf_get_mark(0, '['),
          ['end'] = vim.api.nvim_buf_get_mark(0, ']'),
        }
      })
    end
    vim.opt.opfunc = 'v:lua.LspFormatMotion'
    return 'g@'
  end, { expr = true, buffer = true })
  vim.keymap.set('n', '==', function()
    if not client.supports_method('textDocument/formatting') then
      vim.api.nvim_feedkeys('==', 'in', false)
      return
    end
    local startpos = vim.api.nvim_win_get_cursor(0)
    local endpos = { startpos[1] + vim.v.count, 999 }
    vim.lsp.buf.format({
      range = {
        ['start'] = startpos,
        ['end'] = endpos,
      }
    })
  end, { buffer = true })

  -- integration with nvim-navic
  if client and client.server_capabilities
            and client.server_capabilities.documentSymbolProvider then
    local status, navic = pcall(require, 'nvim-navic')
    if status then
      navic.attach(client, bufnr)
    end
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = 'utf-8'
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

return default_config
