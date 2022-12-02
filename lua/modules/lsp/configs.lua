local M = {}

M['nvim-lspconfig'] = function()
  local static = require('utils.static')
  local ensure_installed = static.langs:list('lsp_server')
  local icons = static.icons

  local function lspconfig_setui()
    -- Customize LSP floating window border
    local floating_preview_opts = { border = 'single' }
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
  end

  local function on_attach(_, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    local buf_set_option = function(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local keymaps = {
      { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>' },
      { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>' },
      { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>' },
      { 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>' },
      { 'n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>' },
      { 'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>' },
      { 'n', '<Leader>wd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>' },
      { 'n', '<Leader>wl', '<cmd>lua vim.pretty_print(vim.lsp.buf.list_workspace_folders())<CR>' },
      { 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>' },
      { 'n', '<Leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>' },
      { 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>' },
      { 'n', '<Leader>R', '<cmd>lua vim.lsp.buf.references()<CR>' },
      { 'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>' },
      { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
      { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
      { 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
      { 'n', '<leader>=', '<cmd>lua vim.lsp.buf.format()<CR>' },
      { 'v', '<leader>=', '<cmd>lua vim.lsp.buf.format()<CR>' },
    }
    for _, map in ipairs(keymaps) do
      -- use <unique> to avoid overriding lspsaga keymaps
      vim.cmd(string.format('silent! %snoremap <buffer> <silent> <unique> %s %s',
            unpack(map)))
    end
  end

  local function lsp_setup()
    -- Add additional capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = 'utf-8'
    local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if cmp_nvim_lsp_ok then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end
    local function get_lsp_server_cfg(name)
      local status, server_config = pcall(require, 'modules/lsp/lsp-server-configs/' .. name)
      if not status then
        return {}
      else
        return server_config
      end
    end
    for _, server_name in pairs(ensure_installed) do
      require('lspconfig')[server_name].setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = get_lsp_server_cfg(server_name),
      })
    end
  end

  lspconfig_setui()
  lsp_setup()
end

M['mason.nvim'] = function()
  require('mason').setup({
    ui = {
      border = 'single',
      icons = {
        package_installed = '',
        package_pending = '',
        package_uninstalled = '',
      },
      keymaps = {
        -- Keymap to expand a package
        toggle_package_expand = '<Tab>',
        -- Keymap to uninstall a package
        uninstall_package = 'x',
      },
    },
  })
end

M['mason-lspconfig.nvim'] = function()
  require('mason-lspconfig').setup({
    ensure_installed = require('utils.static').langs:list('lsp_server'),
  })
end

M['lspsaga.nvim'] = function()

  local icons = require('utils.static').icons

  local function gen_custom_kind()
    local valid_types = {
      File = {},
      Module = {},
      Namespace = {},
      Package = {},
      Class = {},
      Method = {},
      Property = {},
      Field = {},
      Constructor = {},
      Enum = {},
      Interface = {},
      Function = {},
      Variable = {},
      Constant = {},
      String = {},
      Number = {},
      Boolean = {},
      Array = {},
      Object = {},
      Key = {},
      Null = {},
      EnumMember = {},
      Struct = {},
      Event = {},
      Operator = {},
      TypeParameter = {},
      TypeAlias = {},
      Parameter = {},
      StaticMethod = {},
      Macro = {},
    }

    local function get_hl(name)
      local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
      if not ok then return nil end
      for _, key in pairs({'foreground', 'background', 'special'}) do
        if hl[key] then hl[key] = string.format('#%06x', hl[key]) end
      end
      return hl
    end

    for typename, _ in pairs(valid_types) do
      local hlgroup = get_hl(string.format('CmpItemKind%s', typename)) or
                      get_hl(string.format('TS%s', typename)) or
                      get_hl(typename) or
                      get_hl('Normal') or
                      { foreground = require('colors.nvim-falcon.palette').white }
      if icons[typename] then
        valid_types[typename] = { icons[typename], hlgroup.foreground }
      else
        valid_types[typename] = nil
      end
    end
    return valid_types
  end

  require('lspsaga').init_lsp_saga({
    diagnostic_header = {
      icons.DiagnosticSignError,
      icons.DiagnosticSignWarn,
      icons.DiagnosticSignInfo,
      icons.DiagnosticSignHint,
    },
    code_action_icon = '',
    -- finder icons
    finder_icons = {
      def = ' ',
      ref = ' ',
      link = ' ',
    },
    finder_action_keys = {
      open = { 'o', '<CR>' },
      quit = { 'q', '<ESC>' },
      vsplit = '<M-v>',
      split = '<M-s>',
      tabe = '<M-t>',
    },
    code_action_keys = {
      quit = 'q',
      exec = '<CR>',
    },
    definition_action_keys = {
      edit = '<CR>',
      vsplit = '<M-v>',
      split = '<M-s>',
      tabe = '<M-t>',
      quit = 'q',
    },
    rename_action_quit = '<C-c>',
    show_outline = {
      win_position = 'right',
      win_width = 40,
      auto_enter = true,
      auto_preview = true,
      virt_text = '',
      jump_key = '<CR>',
      auto_refresh = true,
    },
    symbol_in_winbar = {
      enable = true,
      in_custom = true,
      show_file = false,
      separator = ' -> ',
      click_support = function(node, clicks, button, modifiers)
        local st = node.range.start
        local en = node.range['end']
        if button == 'l' then
          if clicks == 2 then
            -- double left click to do nothing
          else -- jump to node's starting line+char
            vim.fn.cursor(st.line + 1, st.character + 1)
          end
        elseif button == 'r' then
          if modifiers == 's' then
            print('lspsaga')  -- shift right click to print 'lspsaga'
          end -- jump to node's ending line+char
          vim.fn.cursor(en.line + 1, en.character + 1)
        elseif button == 'm' then
          -- middle click to visual select node
          vim.fn.cursor(st.line + 1, st.character + 1)
          vim.cmd 'normal v'
          vim.fn.cursor(en.line + 1, en.character + 1)
        end
      end,
    },
    custom_kind = gen_custom_kind(),
  })

  local function get_fpath_proj_relative()
    local file_name = require('lspsaga.symbolwinbar').get_file_name(nil)
    if vim.fn.bufname '%' == '' then return '' end
    -- Else if include path: ./lsp/saga.lua -> lsp > saga.lua
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local file_path = ''
    for _, cur in ipairs(path_list) do
      file_path = (cur == '.' or cur == '~') and '' or
                  file_path .. cur .. ' ' .. '%#LspSagaWinbarSep#>%*' .. ' %*'
    end
    return file_path .. file_name
  end

  local function update_winbar()
    local exclude = {
      ['terminal'] = true,
      ['toggleterm'] = true,
      ['prompt'] = true,
      ['NvimTree'] = true,
      ['help'] = true,
    } -- Ignore float windows and exclude filetype
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
      vim.wo.winbar = ''
    else
      local ok, lspsaga = pcall(require, 'lspsaga.symbolwinbar')
      local sym
      if ok then sym = lspsaga.get_symbol_node() end
      local win_val = ' ' .. get_fpath_proj_relative()
      if sym ~= nil then win_val = win_val .. ': ' .. sym end
      vim.wo.winbar = win_val
    end
  end

  vim.api.nvim_create_augroup('Winbar', {})
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'CursorMoved' }, {
    pattern = '*',
    callback = update_winbar,
    group = 'Winbar',
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = update_winbar,
    group = 'Winbar',
  })

  vim.keymap.set('n', '<leader>R', '<cmd>Lspsaga lsp_finder<CR>', { silent = true })
  vim.keymap.set('n', '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true })
  vim.keymap.set('n', '<leader>r', '<cmd>Lspsaga rename<CR>', { silent = true })
  vim.keymap.set('n', '<leader>K', '<cmd>Lspsaga peek_definition<CR>', { silent = true })
  vim.keymap.set('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<CR>', { silent = true })
  vim.keymap.set('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
  vim.keymap.set('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
  vim.keymap.set('n', '[E', function()
    require('lspsaga.diagnostic').goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { silent = true })
  vim.keymap.set('n', ']E', function()
    require('lspsaga.diagnostic').goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { silent = true })
  vim.keymap.set('n','<leader>o', '<cmd>LSoutlineToggle<CR>',{ silent = true })
end

return M
