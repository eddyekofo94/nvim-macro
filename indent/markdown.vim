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
  let l:prev_line_trimmed = substitute(l:prev_line, '^\s*', '', '')
  let l:eq_pos = match(l:prev_line_trimmed, '&\?=')
  if l:eq_pos >= 0 && l:line =~# '^\s*&\?='
    return indent(l:prev_lnum) + l:eq_pos
  endif

  " Align unordered list multi-line items
  let l:list_extra_indent = match(l:prev_line_trimmed, '\(^[-*+]\s*\)\@<=\S')
  if l:list_extra_indent >= 0
    return indent(l:prev_lnum) + l:list_extra_indent
  endif

  " Align ordered list multi-line items
  let l:ordered_list_extra_indent =
        \ match(l:prev_line_trimmed, '\(^\d\+\.\s*\)\@<=\S')
  if l:ordered_list_extra_indent >= 0
    return indent(l:prev_lnum) + l:ordered_list_extra_indent
  endif

  return indent(v:lnum)
endfunction
