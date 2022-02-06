local get = require('utils/get')
local langs = require('utils/shared').langs
local ensure_installed = get.lsp_server_list(langs)

--------------------------------------------------------------------------------
-- LSP UI configs --------------------------------------------------------------

-- Config for `nvim-lsp-installer` icons
require('nvim-lsp-installer').settings({
  ui = {
    icons = {
      server_installed = '',
      server_pending = '',
      server_uninstalled = ''
    }
  }
})

-- Customize LSP floating window border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'single'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- LSP diagnostic signs
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = {
      spacing = 4,
      prefix = ''
    }
  }
)

-- Show diagnostics automatically in hover
-- vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- Goto definition in split window
local function goto_definition(split_cmd)
  local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api
  -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
  local handler = function(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end
    if split_cmd then
      vim.cmd(split_cmd)
    end
    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])
      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result)
    end
  end
  return handler
end
vim.lsp.handlers["textDocument/definition"] = goto_definition('vsplit')

-- End of LSP UI configs -------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Pass config table to each LSP server: ---------------------------------------

-------------------------- on_attach function begins ---------------------------
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach =
  function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap=true }
    buf_set_keymap('n', '<Leader>lD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', '<Leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', '<Leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<Leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<Leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>lwd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<Leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<Leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<Leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<Leader>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<Leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    buf_set_keymap('n', '<leader>l=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
--------------------------- on_attach function ends ----------------------------

-- Ensure `cmp-nvim-lsp` and `nvim-lspconfig` are loaded
vim.cmd [[ packadd cmp-nvim-lsp ]]
vim.cmd [[ packadd nvim-lspconfig ]]

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Automatically install servers in `ensure_installed`
-- and add additional capabilities supported by nvim-cmp
for _, server_name in pairs(ensure_installed) do
  local server_available, requested_server
    = require('nvim-lsp-installer').get_server(server_name)
  if server_available then
    if not requested_server:is_installed() then
      print('[lsp-installer]: installing ' .. server_name)
      requested_server:install()
    end
    requested_server:on_ready(function()
      requested_server:setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = get.lsp_server_config(server_name)
      }
    end)
  else
    print('[lsp-installer]: server ' .. server_name .. ' not available')
  end
end

-- Passed config table to each LSP server --------------------------------------
--------------------------------------------------------------------------------
