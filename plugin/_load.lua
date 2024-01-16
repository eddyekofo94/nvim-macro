-- Lazy-load rplugins and builtin plugins

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

-- lsp-diagnostic
vim.api.nvim_create_autocmd({ 'LspAttach', 'DiagnosticChanged' }, {
  once = true,
  desc = 'Apply lsp and diagnostic settings.',
  group = vim.api.nvim_create_augroup('LspDiagnosticSetup', {}),
  callback = function()
    require('plugin.lsp-diagnostic').setup()
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

-- load rplugins on FileType event

---Rename rplugin manifest so that we can load it on demand
---Side effect: sets `vim.g.rplugin` to the renamed manifest path
---@return nil
local function _disable_rplugin()
  if vim.g.rplugin then
    return
  end

  local rplugin = vim.env.NVIM_RPLUGIN_MANIFEST
    or vim.fs.joinpath(vim.fn.stdpath('data') --[[@as string]], 'rplugin.vim')
  local rplugin_ = rplugin .. '_'

  if vim.uv.fs_stat(rplugin) then
    vim.uv.fs_rename(rplugin, rplugin_)
  end
  if vim.uv.fs_stat(rplugin_) then
    vim.g.rplugin = rplugin_
  end
end

vim.defer_fn(_disable_rplugin, 200)
vim.api.nvim_create_autocmd('FileType', {
  once = true,
  group = vim.api.nvim_create_augroup('RpluginSetup', {}),
  callback = function()
    if not vim.g.rplugin then
      _disable_rplugin()
    end
    if vim.g.rplugin then
      vim.cmd.source({
        args = { vim.g.rplugin },
        mods = { emsg_silent = true },
      })
    end
  end,
})
