local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')
local headers = require('utils.static').ascii_art

local function make_button(usr_opts, txt, keybind, keybind_opts)
  local sc_after = usr_opts.shortcut:gsub('%s', '')
  local default_opts = {
    position = 'center',
    cursor = 5,
    width = 50,
    align_shortcut = 'right',
    hl_shortcut = 'Lavender'
  }
  local opts = vim.tbl_deep_extend('force', default_opts, usr_opts)
  if nil == keybind then
    keybind = sc_after
  end
  keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
  opts.keymap = { 'n', sc_after, keybind, keybind_opts }

  local function on_press()
    -- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
    local key = vim.api.nvim_replace_termcodes(sc_after .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

math.randomseed(os.time())
dashboard.section.header.val = headers[math.random(1, #headers)]
dashboard.section.header.opts.hl = 'White'

local dashboard_button_opts = {
  { { shortcut = 'e', hl = { { 'Tea', 2, 3 } } }, 'ﱐ  New file', '<cmd>ene<CR>' },
  { { shortcut = 's', hl = { { 'Pigeon', 2, 3 } } }, '  Sync plugins', '<cmd>Lazy sync<CR>' },
  { { shortcut = 'c', hl = { { 'Turquoise', 2, 3 } } }, '  Open Config Files', '<cmd>e ' .. vim.fn.stdpath('config') .. '<CR>' },
  { { shortcut = 'g', hl = { { 'Ochre', 2, 3 } } }, '  Git', '<cmd>ToggleTool lazygit<CR>' },
  { { shortcut = 'f f', hl = { { 'Flashlight', 2, 3 } } }, '  Find files', '<cmd>Telescope find_files<CR>' },
  { { shortcut = 'f o', hl = { { 'Smoke', 2, 3 } } }, '  Old files', '<cmd>Telescope oldfiles<CR>' },
  { { shortcut = 'f m', hl = { { 'Earth', 2, 3 } } }, '  Goto bookmark', '<cmd>Telescope marks<CR>' },
  { { shortcut = 'f ;', hl = { { 'White', 2, 3 } } }, '  Live grep', '<cmd>Telescope live_grep<CR>' },
  { { shortcut = 'q', hl = { { 'Wine', 2, 3 } } }, '  Quit', '<cmd>qa<CR>' },
}
dashboard.section.buttons.val = {}
for _, button in ipairs(dashboard_button_opts) do
  table.insert(dashboard.section.buttons.val, make_button(unpack(button)))
end

-- Footer must be a table so that its height is correctly measured
local lazy_ok, lazy = pcall(require, 'lazy')
local stat = lazy_ok and lazy.stats() or { count = '?', loaded = '?' }
dashboard.section.footer.val = { string.format('%d / %d  plugins ﮣ loaded',
  stat.loaded, stat.count) }
dashboard.section.footer.opts.hl = 'Comment'

-- Set paddings
local h_header = #dashboard.section.header.val
local h_buttons = #dashboard.section.buttons.val * 2 - 1
local h_footer = #dashboard.section.footer.val
local pad_tot = vim.o.lines - (h_header + h_buttons + h_footer)
local pad_1 = math.ceil(pad_tot * 0.25)
local pad_2 = math.ceil(pad_tot * 0.20)
local pad_3 = math.floor(pad_tot * 0.20)
dashboard.config.layout = {
  { type = 'padding', val = pad_1 },
  dashboard.section.header,
  { type = 'padding', val = pad_2 },
  dashboard.section.buttons,
  { type = 'padding', val = pad_3 },
  dashboard.section.footer
}

alpha.setup(dashboard.opts)

-- Do not show statusline or tabline in alpha buffer
vim.api.nvim_create_augroup('AlphaSetLine', {})
vim.api.nvim_create_autocmd('User', {
  pattern = 'AlphaReady',
  callback = function()
    if vim.fn.winnr('$') == 1 then
      vim.t.laststatus_save = vim.o.laststatus
      vim.t.showtabline_save = vim.o.showtabline
      vim.o.laststatus = 0
      vim.o.showtabline = 0
    end
  end,
  group = 'AlphaSetLine',
})
vim.api.nvim_create_autocmd('BufUnload', {
  pattern = '*',
  callback = function()
    if vim.bo.ft == 'alpha' then
      vim.o.laststatus = vim.t.laststatus_save
      vim.o.showtabline = vim.t.showtabline_save
    end
  end,
  group = 'AlphaSetLine',
})
