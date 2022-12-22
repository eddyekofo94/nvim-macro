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

  local function on_attach(client, bufnr)

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
      { 'n', '<leader>td', '<cmd>lua vim.lsp.buf.type_definition()<CR>' },
      { 'n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' },
      { 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>' },
      { 'n', '<Leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>' },
      { 'n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>' },
      { 'n', '[E', '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>' },
      { 'n', ']E', '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>' },
      { 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>' },
      { 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>' },
      { 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>' },
      { 'n', '==', '<cmd>lua vim.lsp.buf.format()<CR>' },
      { 'v', '=', '<cmd>lua vim.lsp.buf.format()<CR>' },
    }
    for _, map in ipairs(keymaps) do
      -- use <unique> to avoid overriding telescope keymaps
      vim.cmd(string.format('silent! %snoremap <buffer> <silent> <unique> %s %s',
            unpack(map)))
    end

    -- integration with nvim-navic
    if client.server_capabilities.documentSymbolProvider then
      require('nvim-navic').attach(client, bufnr)
    end
  end

  local function get_override_config(name)
    local status, override_config
      = pcall(require, 'modules/lsp/lsp-server-configs/' .. name)
    if not status then
      return nil
    else
      return override_config.on_new_config
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
  for _, server_name in pairs(ensure_installed) do
    require('lspconfig')[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      on_new_config = get_override_config(server_name),
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

M['aerial.nvim'] = function()
  require('aerial').setup({
    keymaps = {
      ['<M-v>'] = 'actions.jump_vsplit',
      ['<M-s>'] = 'actions.jump_split',
      ['<Tab>'] = 'actions.scroll',
      ['p'] = 'actions.prev_up',

      ['?'] = false,
      ['<C-v>'] = false,
      ['<C-s>'] = false,
      ['[['] = false,
      [']]'] = false,
      ['l'] = false,
      ['L'] = false,
      ['h'] = false,
      ['H'] = false,
    },
    attach_mode = 'global',
    backends = { 'lsp', 'markdown', 'man' },
    disable_max_lines = 8192,
    filter_kind = false,
    icons = require('utils.static').icons,
    ignore = {
      filetypes = { 'aerial', 'help', 'alpha', 'undotree', 'TelescopePrompt' },
    },
    link_folds_to_tree = true,
    link_tree_to_folds = true,
    manage_folds = true,
    layout = {
      max_width = { 0.2 },
      min_width = 20,
    },
    show_guides = true,
    float = { border = 'single' },
    treesitter = { update_delay = 10 },
    markdown = { update_delay = 10 }
  })

  vim.keymap.set('n', '<Leader>o', '<Cmd>AerialToggle<CR>', { noremap = true })
end

M['nvim-navic'] = function()
  local navic = require('nvim-navic')
  navic.setup({
      icons = require('utils.static').icons,
      highlight = true,
      separator = ' ► ',
      depth_limit = 0,
      depth_limit_indicator = '…',
      safe_output = true
  })

  local function get_fpath_proj_relative()
    local fname = vim.fn.expand('%:t')
    local icon, iconcolor = require('nvim-web-devicons').get_icon(fname,
        vim.fn.fnamemodify(fname, ':e'), { default = true })
    fname = string.format('%%#%s#%s %%*%s%%*', iconcolor, icon, fname)
    if vim.fn.bufname('%') == '' then return '' end
    local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
    local path_list = vim.split(string.gsub(vim.fn.expand '%:~:.:h', '%%', ''), sep)
    local fpath = ''
    for _, cur in ipairs(path_list) do
      fpath = (cur == '.' or cur == '~') and '' or
                  fpath .. cur .. ' %#Tea#►%* ' .. '%*'
    end
    return fpath .. fname
  end

  function _G.update_winbar()
    local sym = navic.get_location()
    local win_val = ' ' .. get_fpath_proj_relative()
    if sym ~= nil and sym ~= '' then
      win_val = win_val .. ' %#Orange#► '
          .. sym:gsub('%s+%%%*%%#NavicText#%s+%%%*%%#NavicSeparator#%s+',
                      '%%%*%%#NavicText#%%%*%%#NavicSeparator# ')
    end
    return win_val
  end

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave', }, {
    pattern = '*',
    callback = function()
      local exclude = {
        ['terminal'] = true,
        ['prompt'] = true,
        ['help'] = true,
        ['checkhealth'] = true,
        ['aerial'] = true,
        ['undotree'] = true,
        ['floaterm'] = true,
        [''] = true,
      } -- Ignore float windows and exclude filetype
      if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
        vim.wo.winbar = nil
      else
        vim.wo.winbar = "%{%v:lua.update_winbar()%}"
      end
    end,
  })
end

return M
