local toggleterm = require('toggleterm')
local terminal = require('toggleterm.terminal')

toggleterm.setup({
  open_mapping = '<C-\\><C-\\>',
  shade_terminals = false,
  hide_numbers = true,
  autochdir = true,
  persist_size = false,
  direction = 'horizontal',
  float_opts = {
    border = 'shadow',
    width = function()
      return math.floor(vim.go.columns * 0.7)
    end,
    height = function()
      return math.floor(vim.go.lines * 0.7)
    end,
    winblend = 0,
  },
  size = function(term)
    if term.direction == 'horizontal' then
      return vim.go.lines * 0.3
    elseif term.direction == 'vertical' then
      return vim.go.columns * 0.35
    end
  end,
  highlights = {
    NormalFloat = { link = 'NormalFloat' },
    FloatBorder = { link = 'FloatBorder' },
    WinBarActive = { link = 'WinBar' },
    WinBarInactive = { link = 'WinBarNC' },
  },
  winbar = {
    enabled = false,
  },
  on_open = function()
    vim.cmd('silent! normal! 0')
    vim.cmd('silent! startinsert!')
  end,
})

local lazygit = terminal.Terminal:new({
  count = 999,
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
})

---Toggle lazygit
local function lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set({ 't', 'n' }, '<C-\\>g', lazygit_toggle)
vim.keymap.set({ 't', 'n' }, '<C-\\><C-g>', lazygit_toggle)

-- stylua: ignore start
vim.keymap.set({ 't', 'n' }, '<C-\\>v',     function() toggleterm.toggle_command('direction=vertical',   vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\>s',     function() toggleterm.toggle_command('direction=horizontal', vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\>t',     function() toggleterm.toggle_command('direction=tab',        vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\>f',     function() toggleterm.toggle_command('direction=float',      vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\><C-v>', function() toggleterm.toggle_command('direction=vertical',   vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\><C-s>', function() toggleterm.toggle_command('direction=horizontal', vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\><C-t>', function() toggleterm.toggle_command('direction=tab',        vim.v.count) end)
vim.keymap.set({ 't', 'n' }, '<C-\\><C-f>', function() toggleterm.toggle_command('direction=float',      vim.v.count) end)
-- stylua: ignore end

-- Hijack toggleterm's toggle_command function to set splitkeep option before
-- opening a terminal and restore it after opening it
local _toggle_command = toggleterm.toggle_command
function toggleterm.toggle_command(args, count)
  vim.g.splitkeep = vim.go.splitkeep
  vim.go.splitkeep = 'screen'
  _toggle_command(args, count)
  vim.go.splitkeep = vim.g.splitkeep
end
