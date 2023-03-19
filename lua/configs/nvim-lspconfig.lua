local static = require('utils.static')
local ensure_installed = static.langs:list('lsp_server')
local icons = static.icons

local function lspconfig_setui()
  -- Customize LSP floating window border
  local floating_preview_opts = { border = 'solid' }
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = vim.tbl_deep_extend('force', opts, floating_preview_opts)
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
  local diagnostic_opts = {}
  -- LSP diagnostic signs
  diagnostic_opts.signs = {
    { 'DiagnosticSignError', { text = icons.DiagnosticSignError, texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' } },
    { 'DiagnosticSignWarn', { text = icons.DiagnosticSignWarn, texthl = 'DiagnosticSignWarn', numhl = 'DiagnosticSignWarn' } },
    { 'DiagnosticSignInfo', { text = icons.DiagnosticSignInfo, texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' } },
    { 'DiagnosticSignHint', { text = icons.DiagnosticSignHint, texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' } },
    { 'DiagnosticSignOk', { text = icons.DiagnosticSignOk, texthl = 'DiagnosticSignOk', numhl = 'DiagnosticSignOk' } },
  }
  for _, sign_settings in ipairs(diagnostic_opts.signs) do
    vim.fn.sign_define(unpack(sign_settings))
  end
  diagnostic_opts.handlers = {
    -- Enable underline, use default values
    underline = true,
    -- Enable virtual text, override spacing to 4
    virtual_text = {
      spacing = 4,
      prefix = ''
    },
  }
  vim.lsp.handlers['textDocument/publishDiagnostics']
      = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                     diagnostic_opts.handlers)
  -- setup LspInfo floating window border
  require('lspconfig.ui.windows').default_options.border = 'solid'
  -- reload LspInfo floating window on VimResized
  vim.api.nvim_create_autocmd('VimResized', {
    pattern = '*',
    callback = function()
      if vim.bo.ft == 'lspinfo' then
        vim.api.nvim_win_close(0, true)
        vim.cmd('LspInfo')
      end
    end,
  })
end

local function get_server_config(server_name)
  local status, config
    = pcall(require, 'configs.lsp-server-configs.' .. server_name)
  if not status then
    return require('configs.lsp-server-configs.shared.default')
  else
    return config
  end
end

local function lsp_setup()
  for _, server_name in pairs(ensure_installed) do
    require('lspconfig')[server_name].setup(get_server_config(server_name))
  end
end

lspconfig_setui()
lsp_setup()
