-- Override the default fugitive commands to save the previous buffer
-- before opening the log window.
vim.cmd([[
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete Gclog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete GcLog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "c")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete Gllog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
  command! -bang -nargs=? -range=-1 -complete=customlist,fugitive#LogComplete GlLog let g:fugitive_prevbuf=bufnr() | exe fugitive#LogCommand(<line1>,<count>,+"<range>",<bang>0,"<mods>",<q-args>, "l")
]])

vim.keymap.set('n', '<Leader>gd', '<Cmd>Gdiff<CR>')
vim.keymap.set('n', '<Leader>gD', '<Cmd>Git diff<CR>')
vim.keymap.set('n', '<Leader>gB', '<Cmd>Git blame<CR>')
vim.keymap.set('n', '<Leader>gl', '<Cmd>0Gllog<CR>')
vim.keymap.set('n', '<Leader>gq', function()
  if vim.g.fugitive_prevbuf and (vim.bo.ft == 'git' or vim.bo.ft == 'qf') then
    vim.cmd.cclose()
    vim.cmd.lclose()
    vim.cmd.buffer(vim.g.fugitive_prevbuf)
  end
end)

local groupid = vim.api.nvim_create_augroup('FugitiveSettings', {})
vim.api.nvim_create_autocmd('User', {
  pattern = 'FugitiveIndex',
  group = groupid,
  callback = function(info)
    vim.keymap.set({ 'n', 'x' }, 'S', 's', { buffer = info.buf, remap = true })
    vim.keymap.set({ 'n', 'x' }, 'x', 'X', { buffer = info.buf, remap = true })
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'FugitiveObject',
  group = groupid,
  callback = function()
    -- stylua: ignore start
    local goto_next = [[<Cmd>silent! exe "if get(getloclist(0, {'winid':''}), 'winid', 0) | exe v:count.'lne' | else | exe v:count.'cn' | endif"<CR>]]
    local goto_prev = [[<Cmd>silent! exe "if get(getloclist(0, {'winid':''}), 'winid', 0) | exe v:count.'lpr' | else | exe v:count.'cp' | endif"<CR>]]
    -- stylua: ignore end
    vim.keymap.set('n', '<C-n>', goto_next, { buffer = true })
    vim.keymap.set('n', '<C-p>', goto_prev, { buffer = true })
    vim.keymap.set('n', '<C-j>', goto_next, { buffer = true })
    vim.keymap.set('n', '<C-k>', goto_prev, { buffer = true })
    vim.keymap.set('n', '<C-^>', function()
      if vim.g.fugitive_prevbuf then
        vim.cmd.cclose()
        vim.cmd.lclose()
        vim.cmd.buffer(vim.g.fugitive_prevbuf)
      end
    end, { buffer = true })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set buffer-local options for fugitive buffers.',
  group = groupid,
  pattern = 'fugitive',
  callback = function()
    vim.opt_local.winbar = nil
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set buffer-local options for fugitive blame buffers.',
  group = groupid,
  pattern = 'fugitiveblame',
  callback = function()
    local win_alt = vim.fn.win_getid(vim.fn.winnr('#'))
    vim.opt_local.winbar = vim.api.nvim_win_is_valid(win_alt)
        and vim.wo[win_alt].winbar ~= ''
        and ' '
      or ''

    vim.opt_local.number = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.relativenumber = false
  end,
})
