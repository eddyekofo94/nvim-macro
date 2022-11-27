local M = {}

M['nvim-lspconfig'] = function()
  local ensure_installed = require('utils.static').langs:list('lsp_server')

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
      { 'DiagnosticSignError', { text = ' ', texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' } },
      { 'DiagnosticSignWarn', { text = ' ', texthl = 'DiagnosticSignWarn', numhl = 'DiagnosticSignWarn' } },
      { 'DiagnosticSignInfo', { text = ' ', texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' } },
      { 'DiagnosticSignHint', { text = ' ', texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' } },
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
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local keymap_opts = { noremap = true, silent = true }
    local keymaps = {
      { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts },
      { 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts },
      { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts },
      { 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts },
      { 'n', '<Leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts },
      { 'n', '<Leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', keymap_opts },
      { 'n', '<Leader>lwd', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', keymap_opts },
      { 'n', '<Leader>lwl', '<cmd>lua vim.pretty_print(vim.lsp.buf.list_workspace_folders())<CR>', keymap_opts },
      { 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts },
      { 'n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts },
      { 'n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts },
      { 'n', '<Leader>lR', '<cmd>lua vim.lsp.buf.references()<CR>', keymap_opts },
      { 'n', '<Leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', keymap_opts },
      { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', keymap_opts },
      { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', keymap_opts },
      { 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', keymap_opts },
      { 'n', '<leader>l=', '<cmd>lua vim.lsp.buf.format()<CR>', keymap_opts },
    }
    local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local buf_set_option = function(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    for _, map in ipairs(keymaps) do
      buf_set_keymap(unpack(map))
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
      local status, server_config = pcall(require, 'modules/langs/lsp-server-configs/' .. name)
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

M['nvim-treesitter'] = function()
  local ts_configs = require('nvim-treesitter.configs')
  ts_configs.setup({
    ensure_installed = require('utils.static').langs:list('ts'),
    sync_install = true,
    ignore_install = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    context_commentstring = {
      enable = true,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1024,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gnn',
        node_incremental = 'grn',
        scope_incremental = 'grc',
        node_decremental = 'grm',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['am'] = '@function.outer',
          ['im'] = '@function.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ak'] = '@class.outer',
          ['ik'] = '@class.inner',
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
          ['a/'] = '@comment.outer',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@function.outer',
          [']k'] = '@class.outer',
          [']a'] = '@parameter.outer'
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@function.outer',
          [']K'] = '@class.outer',
          [']A'] = '@parameter.outer'
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@function.outer',
          ['[k'] = '@class.outer',
          ['[a'] = '@parameter.outer'
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@function.outer',
          ['[K'] = '@class.outer',
          ['[A'] = '@parameter.outer'
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>al'] = '@parameter.inner'
        },
        swap_previous = {
          ['<leader>ah'] = '@parameter.inner'
        },
      },
      lsp_interop = {
        enable = true,
        border = 'single',
        peek_definition_code = {
          ['<leader>k'] = '@function.outer',
          ['<leader>K'] = '@class.outer',
        },
      },
    },
  })
end

M['mason.nvim'] = function()
  require('mason').setup({
    ui = {
      border = 'double',
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
  require('lspsaga').init_lsp_saga({
    diagnostic_header = { ' ', ' ', ' ', ' ' },
    code_action_icon = ' ',
    -- finder icons
    finder_icons = {
      def = ' ',
      ref = ' ',
      link = ' ',
    },
    finder_action_keys = {
      open = {'o', '<CR>'},
      quit = {'q', '<ESC>'},
      vsplit = 'v',
      split = 's',
      tabe = 't',
    },
    code_action_keys = {
      quit = { 'q', '<ESC>' },
      exec = '<CR>',
    },
    definition_action_keys = {
      edit = '<C-c>o',
      vsplit = '<C-c>v',
      split = '<C-c>i',
      tabe = '<C-c>t',
      quit = 'q',
    },
    rename_action_quit = '<C-c>',
    symbol_in_winbar = {
      enable = true,
      in_custom = true,
      show_file = false,
      separator = ' -> ',
      click_support = function(node, clicks, button, modifiers)
        -- To see all avaiable details: vim.pretty_print(node)
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
            print 'lspsaga' -- shift right click to print 'lspsaga'
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
  })

  local function get_file_name()
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
      local win_val = get_file_name()
      if sym ~= nil then win_val = win_val .. ': ' .. sym end
      vim.wo.winbar = win_val
    end
  end

  vim.api.nvim_create_augroup('Winbar', {})
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'CursorMoved' }, {
    pattern = '*',
    callback = function() update_winbar() end,
    group = 'Winbar',
  })
  vim.api.nvim_create_autocmd('User', {
    pattern = 'LspsagaUpdateSymbol',
    callback = function() update_winbar() end,
    group = 'Winbar',
  })

  vim.keymap.set('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>', { silent = true })
  vim.keymap.set({ 'n','v' }, '<leader>ca', '<cmd>Lspsaga code_action<CR>', { silent = true })
  vim.keymap.set('n', 'gr', '<cmd>Lspsaga rename<CR>', { silent = true })
  vim.keymap.set('n', 'gd', '<cmd>Lspsaga peek_definition<CR>', { silent = true })
  vim.keymap.set('n', '<leader>cd', '<cmd>Lspsaga show_line_diagnostics<CR>', { silent = true })
  vim.keymap.set('n', '<leader>cd', '<cmd>Lspsaga show_cursor_diagnostics<CR>', { silent = true })
  vim.keymap.set('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true })
  vim.keymap.set('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true })
  vim.keymap.set('n', '[E', function()
    require('lspsaga.diagnostic').goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { silent = true })
  vim.keymap.set('n', ']E', function()
    require('lspsaga.diagnostic').goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { silent = true })
  vim.keymap.set('n','<leader>o', '<cmd>LSoutlineToggle<CR>',{ silent = true })
  vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>', { silent = true })
  vim.keymap.set('n', '<A-d>', '<cmd>Lspsaga open_floaterm<CR>', { silent = true })
  vim.keymap.set('n', '<A-d>', '<cmd>Lspsaga open_floaterm lazygit<CR>', { silent = true })
  vim.keymap.set('t', '<A-d>', '<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>', { silent = true })
end

return M
