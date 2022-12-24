command! -count=1 WinResizeLeft lua require('plugin.win_resize').resize_left(<count>)
command! -count=1 WinResizeDown lua require('plugin.win_resize').resize_down(<count>)
command! -count=1 WinResizeUp lua require('plugin.win_resize').resize_up(<count>)
command! -count=1 WinResizeRight lua require('plugin.win_resize').resize_right(<count>)

silent! nnoremap <silent> <unique> <M-C-h> <Cmd>execute (v:count == 0 ? 1 : v:count) . 'WinResizeLeft'<CR>
silent! nnoremap <silent> <unique> <M-C-j> <Cmd>execute (v:count == 0 ? 1 : v:count) . 'WinResizeDown'<CR>
silent! nnoremap <silent> <unique> <M-C-k> <Cmd>execute (v:count == 0 ? 1 : v:count) . 'WinResizeUp'<CR>
silent! nnoremap <silent> <unique> <M-C-l> <Cmd>execute (v:count == 0 ? 1 : v:count) . 'WinResizeRight'<CR>
