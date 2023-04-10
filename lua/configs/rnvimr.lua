vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders none' }
vim.g.rnvimr_draw_border = 0
vim.g.rnvimr_action = {
  ['<A-t>'] = 'NvimEdit tabedit',
  ['<A-s>'] = 'NvimEdit split',
  ['<A-v>'] = 'NvimEdit vsplit',
  ['gw'] = 'JumpNvimCwd',
  ['yw'] = 'EmitRangerCwd',
}

local function rnvimr_update_layout()
  vim.g.rnvimr_layout = {
    relative = 'editor',
    anchor = 'NW',
    row = math.floor(0.15 * vim.go.lines),
    col = math.ceil(0.15 * vim.go.columns),
    width = math.floor(0.7 * vim.go.columns),
    height = math.floor(0.7 * vim.go.lines),
    style = 'minimal',
    border = 'shadow',
  }
end
rnvimr_update_layout()
vim.api.nvim_create_augroup('RnvimrUpdateLayout', {})
vim.api.nvim_create_autocmd('VimResized', {
  pattern = '*',
  group = 'RnvimrUpdateLayout',
  callback = rnvimr_update_layout,
})

local function change_highlight_colorscheme()
  if vim.o.background == 'dark' then
    os.execute(
      'ln -fs ~/.highlight/themes/falcon-dark.theme '
        .. '~/.highlight/themes/falcon.theme'
    )
  else
    os.execute(
      'ln -fs ~/.highlight/themes/falcon-light.theme '
        .. '~/.highlight/themes/falcon.theme'
    )
  end
end

local function rnvimr_toggle()
  local winlist = vim.api.nvim_list_wins()
  for _, winnr in ipairs(winlist) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if
      vim.api.nvim_win_get_config(winnr).relative ~= ''
      and vim.fn.getwinvar(winnr, '&buftype') == 'terminal'
      and vim.fn.getbufvar(bufnr, '&filetype') ~= 'rnvimr'
    then
      vim.api.nvim_win_close(winnr, true)
    end
  end
  change_highlight_colorscheme()
  vim.cmd('silent! RnvimrToggle')
end

vim.keymap.set({ 'n', 't' }, '<C-\\>e', rnvimr_toggle)
vim.keymap.set({ 'n', 't' }, '<C-\\><C-e>', rnvimr_toggle)

vim.api.nvim_create_augroup('RnvimRSetHl', { clear = true })
vim.api.nvim_create_autocmd({ 'TermOpen', 'ColorScheme' }, {
  pattern = '*',
  group = 'RnvimRSetHl',
  callback = change_highlight_colorscheme,
})

vim.api.nvim_create_autocmd('VimLeave', {
  pattern = '*',
  group = 'RnvimRSetHl',
  callback = function()
    os.execute(
      'ln -fs ~/.highlight/themes/falcon-dark.theme '
        .. '~/.highlight/themes/falcon.theme'
    )
  end,
})
