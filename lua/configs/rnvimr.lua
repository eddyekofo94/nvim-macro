vim.g.rnvimr_enable_ex = 1
vim.g.rnvimr_enable_picker = 1
vim.g.rnvimr_enable_bw = 1
vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders both' }
vim.g.rnvimr_action = {
  ['<A-t>'] = 'NvimEdit tabedit',
  ['<A-s>'] = 'NvimEdit split',
  ['<A-v>'] = 'NvimEdit vsplit',
  ['gw'] = 'JumpNvimCwd',
  ['yw'] = 'EmitRangerCwd'
}

local function change_highlight_colorscheme()
  if vim.o.background == 'dark' then
    os.execute('ln -fs ~/.highlight/themes/falcon-dark.theme '..
               '~/.highlight/themes/falcon.theme')
  else
    os.execute('ln -fs ~/.highlight/themes/falcon-light.theme ' ..
               '~/.highlight/themes/falcon.theme')
  end
end

vim.keymap.set({ 'n', 't' }, '<M-e>', function()
  local winlist = vim.api.nvim_list_wins()
  for _, winnr in ipairs(winlist) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    if vim.api.nvim_win_get_config(winnr).relative ~= ''
        and vim.fn.getwinvar(winnr, '&buftype') == 'terminal'
        and vim.fn.getbufvar(bufnr, '&filetype') ~= 'rnvimr' then
      vim.api.nvim_win_close(winnr, true)
    end
  end
  change_highlight_colorscheme()
  vim.cmd('silent! RnvimrToggle')
end, { noremap = true })

vim.api.nvim_create_autocmd({ 'TermOpen', 'ColorScheme' }, {
  pattern = '*',
  callback = change_highlight_colorscheme,
})

vim.api.nvim_create_autocmd('VimLeave', {
  pattern = '*',
  callback = function()
    os.execute('ln -fs ~/.highlight/themes/falcon-dark.theme '..
               '~/.highlight/themes/falcon.theme')
  end,
})
