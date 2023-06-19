if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetMarkdownIndent()
setlocal indentkeys=!^F,o,O,0=,0=&=

function! GetMarkdownIndent() abort
  let l:line = getline(v:lnum)
  let l:prev_lnum = prevnonblank(v:lnum - 1)
  let l:prev_line = getline(l:prev_lnum)
  if l:prev_lnum == 0
      return indent(v:lnum)
  endif

  " Align to the equal sign of the previous line
  " if the current line starts with '=' or '&='
  let l:prev_line_eq_pos = l:prev_line =~# '&='
        \ ? match(l:prev_line, '&=')
        \ : match(l:prev_line, '=')
  if l:prev_line_eq_pos >= 0 && l:line =~# '^\s*&\?='
    return l:prev_line_eq_pos
  endif

  return indent(v:lnum)
endfunction
