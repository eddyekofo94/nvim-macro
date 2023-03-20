vim.cmd([[
let g:floaterm_width = 0.7
let g:floaterm_height = 0.74
let g:floaterm_opener = 'edit'
let g:floaterm_borderchars = '        '

function! s:get_bufnr_unnamed(buflist) abort
  for bufnr in a:buflist
    let name = getbufvar(bufnr, 'floaterm_name')
    if empty(name)
      return bufnr
    endif
  endfor
  return -1
endfunction

function! ToggleTool(tool, count) abort
  " Close other floating terminal window if present
  let winlist = filter(range(1, winnr('$')),
    \ 'getwinvar(v:val, "&buftype") ==# "terminal"')
  for winnr in winlist
    if getbufvar(winbufnr(winnr), '&filetype') !=# 'floaterm'
      execute 'silent! ' . winnr . 'wincmd c'
    endif
  endfor

  " If current buffer is a floaterm?
  let bufnr = bufnr('%')
  let buflist = floaterm#buflist#gather()
  if index(buflist, bufnr) == -1
    " find an appropriate floaterm according to the
    " tool name if current buffer is not a floaterm
    let bufnr = empty(a:tool) ?
      \ s:get_bufnr_unnamed(buflist) : floaterm#terminal#get_bufnr(a:tool)
  endif

  " Create a new one if cannot find an appropriate floaterm
  if bufnr == -1
    if empty(a:tool)
      " ToggleTool should only be called from
      " normal mode or terminal mode without bang
      call floaterm#run('new', 0, [visualmode(), 0, 0, 0], '')
    else
      call floaterm#run('new', 0, [visualmode(), 0, 0, 0],
        \ printf('--title=%s($1/$2) --name=%s %s', a:tool, a:tool, a:tool))
    endif
  else  " Current buffer is a floaterm, or current buffer is not
        " a floaterm but an appropriate floaterm is found
    call floaterm#toggle(0, a:count ? a:count : bufnr, '')
    " workaround to prevent lazygit shift left;
    " another workaround here is to use sidlent!
    " to ignore can't re-enter normal mode error
    execute('silent! normal! 0')
  endif
endfunction

command! -nargs=? -count=0 -complete=customlist,floaterm#cmdline#complete_names1
    \ ToggleTool call ToggleTool(<q-args>, <count>)
nnoremap <silent> <M-i> <Cmd>execute v:count . 'ToggleTool lazygit'<CR>
tnoremap <silent> <M-i> <Cmd>execute v:count . 'ToggleTool lazygit'<CR>
nnoremap <silent> <C-\> <Cmd>execute v:count . 'ToggleTool'<CR>
tnoremap <silent> <C-\> <Cmd>execute v:count . 'ToggleTool'<CR>

augroup FloatermSetKeymaps
  autocmd!
  autocmd User FloatermOpen nnoremap <buffer> <silent> <C-S-K> <Cmd>FloatermPrev<CR>
  autocmd User FloatermOpen tnoremap <buffer> <silent> <C-S-K> <Cmd>FloatermPrev<CR>
  autocmd User FloatermOpen nnoremap <buffer> <silent> <S-NL> <Cmd>FloatermNext<CR>
  autocmd User FloatermOpen tnoremap <buffer> <silent> <S-NL> <Cmd>FloatermNext<CR>
augroup END

" Auto resize floaterm when window is resized
augroup FloatermResize
  autocmd!
  autocmd VimResized * if &filetype ==# 'floaterm' | exe 'FloatermHide' | exe 'FloatermShow' | endif
augroup END
]])
