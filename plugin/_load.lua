-- Lazy-load builtin plugins

-- vscode-neovim
if vim.g.vscode then
  vim.fn['plugin#vscode#setup']()
  return
end

-- expandtab
vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  group = vim.api.nvim_create_augroup('SmartExpandtabSetup', {}),
  callback = function()
    require('plugin.expandtab').setup()
    return true
  end,
})

-- im
vim.api.nvim_create_autocmd('ModeChanged', {
  once = true,
  pattern = '*:[ictRss\x13]*',
  group = vim.api.nvim_create_augroup('IMInit', {}),
  callback = function()
    require('plugin.im').setup()
    return true
  end,
})

-- lsp-diags
vim.api.nvim_create_autocmd({ 'LspAttach', 'DiagnosticChanged' }, {
  once = true,
  desc = 'Apply lsp and diagnostic settings.',
  group = vim.api.nvim_create_augroup('LspDiagnosticSetup', {}),
  callback = function()
    require('plugin.lsp-diags').setup()
    return true
  end,
})

-- readline
vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'InsertEnter' }, {
  group = vim.api.nvim_create_augroup('ReadlineSetup', {}),
  once = true,
  callback = function()
    require('plugin.readline').setup()
    return true
  end,
})

-- statuscolumn
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('StatusColumn', {}),
  desc = 'Init statuscolumn plugin.',
  once = true,
  callback = function()
    require('plugin.statuscolumn').setup()
    return true
  end,
})

-- statusline
vim.go.statusline = [[%!v:lua.require'plugin.statusline'.get()]]

-- term
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('TermSetup', {}),
  callback = function(info)
    require('plugin.term').setup(info.buf)
  end,
})

-- tmux
if vim.g.has_ui then
  vim.schedule(function()
    require('plugin.tmux').setup()
  end)
end

-- winbar
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  once = true,
  group = vim.api.nvim_create_augroup('WinBarSetup', {}),
  callback = function()
    local winbar = require('plugin.winbar')
    local api = require('plugin.winbar.api')
    local utils = require('plugin.winbar.utils')
    winbar.setup()

    vim.keymap.set('n', '<Leader>;', api.pick)
    vim.keymap.set('n', '[C', api.goto_context_start)
    vim.keymap.set('n', ']C', api.select_next_context)

    ---Set WinBar & WinBarNC background to Normal background
    ---@return nil
    local function clear_winbar_bg()
      local function _clear_bg(name)
        local hl = utils.hl.get(0, {
          name = name,
          winhl_link = false,
        })
        if hl.bg or hl.ctermbg then
          hl.bg = nil
          hl.ctermbg = nil
          vim.api.nvim_set_hl(0, name, hl)
        end
      end

      _clear_bg('WinBar')
      _clear_bg('WinBarNC')
    end

    clear_winbar_bg()

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('WinBarHlClearBg', {}),
      callback = clear_winbar_bg,
    })
    return true
  end,
})

-- tabout
vim.keymap.set({ 'i', 'c' }, '<Tab>', function()
  require('plugin.tabout').jump(1)
end)
vim.keymap.set({ 'i', 'c' }, '<S-Tab>', function()
  require('plugin.tabout').jump(-1)
end)
