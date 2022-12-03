nnoremap <F5> <Cmd>packadd termdebug\|Termdebug<CR>
au User TermdebugStartPre   let g:termdebug_wide=sort([float2nr(winwidth('$') * 0.4), 80, 28], 'n')[1]
au User TermdebugStartPost  lua vim.api.nvim_win_set_width(0, vim.g.termdebug_wide)
au User TermdebugStartPost  setlocal nobl|
                           \wincmd j|
                           \setlocal nobl|
                           \wincmd k|
                           \wincmd l|
                           \wincmd p
au User TermdebugStartPost  nnoremap <buffer> q <cmd>startinsert<CR>quit<CR>|
                           \nnoremap <buffer> <M-d> <cmd>startinsert<CR>quit<CR>|
                           \nnoremap <buffer> <M-c> <cmd>startinsert<CR>quit<CR>|
                           \nnoremap <buffer> <C-W>c <cmd>startinsert<CR>quit<CR>
