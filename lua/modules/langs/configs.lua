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
      { 'DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' } },
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
      { 'n', '<leader>l=', '<cmd>lua vim.lsp.buf.forma)<CR>', keymap_opts },
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
      capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
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

return M
