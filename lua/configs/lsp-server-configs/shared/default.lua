---Check if there exists an LS that supports the given method
---for the given buffer
---@param method string the method to check for
---@param bufnr number buffer handler
local function supports_method(method, bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Set up keymaps and commands
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function on_attach(_, bufnr)
  -- Use an on_attach function to only map the following keys
  -- stylua: ignore start
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
  -- stylua: ignore end
  vim.keymap.set('n', 'gd', function()
    if supports_method('textDocument/definition', bufnr) then
      vim.lsp.buf.definition()
    else
      vim.api.nvim_feedkeys('gd', 'in', false)
    end
  end, { buffer = bufnr })
  vim.keymap.set('n', 'gD', function()
    if supports_method('textDocument/typeDefinition', bufnr) then
      vim.lsp.buf.type_definition()
    else
      vim.api.nvim_feedkeys('gD', 'in', false)
    end
  end, { buffer = bufnr })
  vim.keymap.set('n', 'K', function()
    if supports_method('textDocument/hover', bufnr) then
      vim.lsp.buf.hover()
    else
      vim.api.nvim_feedkeys('K', 'in', false)
    end
  end, { buffer = bufnr })

  -- Format on save
  vim.b.lsp_format_on_save = vim.g.lsp_format_on_save
  vim.api.nvim_buf_create_user_command(bufnr, 'LspFormat', function(tbl)
    vim.lsp.buf.format({
      bufnr = bufnr,
      range = tbl.range > 0 and {
        ['start'] = { tbl.line1, 0 },
        ['end'] = { tbl.line2, 999 },
      } or nil,
    })
  end, {
    range = '%',
    desc = 'Format current buffer with LSP.',
  })
  vim.api.nvim_buf_create_user_command(bufnr, 'LspFormatOnSave', function(tbl)
    if vim.tbl_contains(tbl.fargs, '?') then
      vim.notify(
        '[LSP] format-on-save: turned '
          .. (vim.b.lsp_format_on_save and 'on' or 'off')
          .. ' locally, '
          .. (vim.g.lsp_format_on_save and 'enabled' or 'disabled')
          .. ' globally',
        vim.log.levels.INFO
      )
      return
    end

    local global = not vim.tbl_contains(tbl.fargs, '--local')

    if vim.tbl_contains(tbl.fargs, 'on') then
      vim.b.lsp_format_on_save = true
      if global then
        vim.g.lsp_format_on_save = true
      end
    elseif vim.tbl_contains(tbl.fargs, 'off') then
      vim.b.lsp_format_on_save = false
      if global then
        vim.g.lsp_format_on_save = false
      end
    else -- toggle
      vim.b.lsp_format_on_save = not vim.b.lsp_format_on_save
      vim.g.lsp_format_on_save = vim.b.lsp_format_on_save
    end

    vim.notify(
      '[LSP] format-on-save: ' .. (vim.b.lsp_format_on_save and 'on' or 'off'),
      vim.log.levels.INFO
    )
  end, {
    nargs = '*',
    complete = function(arg_before, _, _)
      local completion = {
        [''] = { 'on', 'off', 'toggle' },
        ['--'] = { 'local' },
      }
      return completion[arg_before] or {}
    end,
    desc = 'Set LSP format-on-save functionality.',
  })

  local augroup_fmt = 'LspFormat' .. bufnr
  vim.api.nvim_create_augroup(augroup_fmt, { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    group = augroup_fmt,
    callback = function()
      if vim.b.lsp_format_on_save then
        vim.lsp.buf.format({
          bufnr = bufnr,
          timeout_ms = 500,
        })
      end
    end,
    desc = 'LSP format on save.',
  })

  -- Disable / enable diagnostics on mode change
  local augroup_diagnostic = 'LspDiagnostic' .. bufnr
  vim.api.nvim_create_augroup(augroup_diagnostic, { clear = true })
  vim.api.nvim_create_autocmd('ModeChanged', {
    buffer = bufnr,
    group = augroup_diagnostic,
    callback = function(tbl)
      if vim.fn.match(tbl.match, '.*:[iRsS\x13].*') ~= -1 then
        vim.diagnostic.disable(bufnr)
        vim.b._lsp_diagnostics_temp_disabled = true
      elseif vim.b._lsp_diagnostics_temp_disabled then
        vim.diagnostic.enable(bufnr)
        vim.b._lsp_diagnostics_temp_disabled = false
      end
    end,
  })
end

-- Merge default capabilities with extra capabilities provided by cmp-nvim-lsp
local capabilities =
  vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
          deprecatedSupport = true,
          preselectSupport = true,
          tagSupport = {
            valueSet = {
              1, -- Deprecated
            },
          },
          insertReplaceSupport = true,
          resolveSupport = {
            properties = {
              'documentation',
              'detail',
              'additionalTextEdits',
            },
          },
          insertTextModeSupport = {
            valueSet = {
              1, -- asIs
              2, -- adjustIndentation
            },
          },
          labelDetailsSupport = true,
        },
        contextSupport = true,
        insertTextMode = 1,
        completionList = {
          itemDefaults = {
            'commitCharacters',
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          },
        },
      },
    },
  })

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

return default_config
