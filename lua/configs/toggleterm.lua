local toggleterm = require('toggleterm')
local terminal = require('toggleterm.terminal')

toggleterm.setup({
  open_mapping = '<C-\\><C-\\>',
  shade_terminals = false,
  hide_numbers = true,
  autochdir = true,
  persist_size = false,
  direction = vim.go.columns >= 120 and 'vertical' or 'horizontal',
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
    enabled = true,
  },
  on_open = function()
    vim.cmd('silent! stopinsert!')
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
