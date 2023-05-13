local static = require('utils.static')

---Customize LSP floating window border
local function lspconfig_floating_win()
  local opts_override = {}

  ---Set LSP floating window options
  local function set_win_opts()
    opts_override = {
      border = 'solid',
      max_width = math.ceil(vim.go.columns * 0.75),
      max_height = math.ceil(vim.go.lines * 0.4),
    }
  end
  set_win_opts()

  -- Reset LSP floating window options on VimResized
  vim.api.nvim_create_augroup('LspFloatingWinOpts', { clear = true })
  vim.api.nvim_create_autocmd('VimResized', {
    group = 'LspFloatingWinOpts',
    callback = set_win_opts,
  })

  -- Hijack LSP floating window function to use custom options
  local _open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = vim.tbl_deep_extend('force', opts, opts_override)
    return _open_floating_preview(contents, syntax, opts, ...)
  end
end

---Customize LSP diagnostic UI
local function lspconfig_diagnostic()
  local icons = static.icons
  for _, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local sign_name = 'DiagnosticSign' .. severity
    vim.fn.sign_define(sign_name, {
      text = icons[sign_name],
      texthl = sign_name,
      numhl = sign_name,
    })
  end

  vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      -- Enable underline, use default values
      underline = true,
      -- Enable virtual text, override spacing to 4
      virtual_text = {
        spacing = 4,
        prefix = vim.trim(static.icons.DirectionLeft),
      },
    })

  -- Disable LSP diagnostics in diff mode
  vim.api.nvim_create_autocmd('OptionSet', {
    pattern = 'diff',
    group = vim.api.nvim_create_augroup('DiagnosticDisableInDiff', {}),
    callback = function(info)
      if vim.v.option_new == '1' then
        vim.diagnostic.disable(info.buf)
        vim.b._lsp_diagnostics_temp_disabled = true
      elseif
        vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1
        and vim.b._lsp_diagnostics_temp_disabled
      then
        vim.diagnostic.enable(info.buf)
        vim.b._lsp_diagnostics_temp_disabled = nil
      end
    end,
    desc = 'Disable LSP diagnostics in diff mode.',
  })
end

---Customize LspInfo floating window
local function lspconfig_info_win()
  -- setup LspInfo floating window border
  require('lspconfig.ui.windows').default_options.border = 'solid'
  -- reload LspInfo floating window on VimResized
  vim.api.nvim_create_augroup('LspInfoResize', { clear = true })
  vim.api.nvim_create_autocmd('VimResized', {
    pattern = '*',
    group = 'LspInfoResize',
    callback = function()
      if vim.bo.ft == 'lspinfo' then
        vim.api.nvim_win_close(0, true)
        vim.cmd('LspInfo')
      end
    end,
  })
end

local function lspconfig_goto_handers()
  local handlers = {
    ['textDocument/references'] = vim.lsp.handlers['textDocument/references'],
    ['textDocument/definition'] = vim.lsp.handlers['textDocument/definition'],
    ['textDocument/declaration'] = vim.lsp.handlers['textDocument/declaration'],
    ['textDocument/implementation'] = vim.lsp.handlers['textDocument/implementation'],
    ['textDocument/typeDefinition'] = vim.lsp.handlers['textDocument/typeDefinition'],
  }
  for method, handler in pairs(handlers) do
    vim.lsp.handlers[method] = function(err, result, ctx, cfg)
      if not result or type(result) == 'table' and vim.tbl_isempty(result) then
        vim.notify(
          '[LSP] no ' .. method:match('/(%w*)$') .. ' found',
          vim.log.levels.WARN
        )
      end
      handler(err, result, ctx, cfg)
    end
  end
end

---Get LSP server default config from lspconfig
---@param server_name string LSP server name
---@return table config
local function get_server_config(server_name)
  local status, config =
    pcall(require, 'configs.lsp-server-configs.' .. server_name)
  if not status then
    return require('configs.lsp-server-configs.shared.default')
  else
    return config
  end
end

---Setup all LSP servers
local function lsp_setup()
  for _, server_name in pairs(static.langs:list('lsp_server')) do
    require('lspconfig')[server_name].setup(get_server_config(server_name))
  end
end

lspconfig_floating_win()
lspconfig_diagnostic()
lspconfig_info_win()
lspconfig_goto_handers()
lsp_setup()
