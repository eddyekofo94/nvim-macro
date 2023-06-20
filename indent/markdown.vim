if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetMarkdownIndent()
setlocal indentkeys=!^F,o,O,0=,0=&=,0-,0*,0+,.

function! s:in_mathzone() abort
  return !exists('g:loaded_vimtex') || !g:loaded_vimtex
        \ || vimtex#syntax#in_mathzone()
endfunction

function s:in_normalzone() abort
  return !exists('g:loaded_vimtex') || !g:loaded_vimtex
        \ || !vimtex#syntax#in_mathzone()
endfunction

function s:get_list_order(lnum) abort
  return str2nr(matchstr(getline(a:lnum), '\(^\s*\)\@<=\d\+\.\@='))
endfunction

" Find the previous ordered list item
" returns a list of two elements:
"  [0] - the order of the previous item
"  [1] - the line number of the first line of the previous item
function s:prev_ordered_item(lnum) abort
  let l:lnum = prevnonblank(a:lnum - 1)
  let l:indent = indent(l:lnum)
  while l:lnum >= 1
    let l:line = getline(l:lnum)
    let l:order = s:get_list_order(l:lnum)
    if l:order > 0
      return [l:order, l:lnum]
    endif
    let l:lnum = prevnonblank(l:lnum - 1)
    let l:new_indent = indent(l:lnum)
    if l:new_indent <= l:indent
      let l:indent = l:new_indent
    else
      break
    endif
  endwhile
  return [0, 0]
endfunction

function! GetMarkdownIndent() abort
  let l:line = getline(v:lnum)
  let l:prev_lnum = prevnonblank(v:lnum - 1)
  let l:prev_line = getline(l:prev_lnum)
  let l:prev_line_trimmed = substitute(l:prev_line, '^\s*', '', '')
  let l:sw = shiftwidth()
  if l:prev_lnum == 0
      return indent(v:lnum)
  endif

  if s:in_mathzone()
    " Align to the equal sign of the previous line
    " if the current line starts with '=' or '&='
    let l:eq_pos = match(l:prev_line_trimmed, '&\?=')
    if l:eq_pos >= 0 && l:line =~# '^\s*&\?='
      return indent(l:prev_lnum) + l:eq_pos
    endif
  endif

  if s:in_normalzone()
    " Reindent unsordered list bullet points
    if l:line =~# '^\s*[-*+]'
      return indent(v:lnum) / l:sw * l:sw
    endif
    " Reindent ordered list items
    let l:order = s:get_list_order(v:lnum)
    if l:order > 0
      let [l:prev_item_order, l:prev_item_lnum] = s:prev_ordered_item(v:lnum)
      return l:order > l:prev_item_order
            \ ? indent(l:prev_item_lnum)
            \ : indent(l:prev_item_lnum) + l:sw
    endif
    " Only align multi-line list items if adjacent previous line is non-empty
    " ---------------------------------------------
    " 1234. aaa-bbb
    "       ccc <- should align with the 'aaa'
    " ---------------------------------------------
    " 5678. ddd
    "
    "     eee <- should not align with 'ddd'
    " ---------------------------------------------
    if l:prev_lnum == v:lnum - 1
      " Align unordered list multi-line items
      let l:list_extra_indent =
            \ match(l:prev_line_trimmed, '\(^[-*+]\s*\)\@<=\S')
      if l:list_extra_indent >= 0
        return indent(l:prev_lnum) + l:list_extra_indent
      endif
      " Align ordered list multi-line items
      let l:ordered_list_extra_indent =
            \ match(l:prev_line_trimmed, '\(^\d\+\.\s*\)\@<=\S')
      if l:ordered_list_extra_indent >= 0
        return indent(l:prev_lnum) + l:ordered_list_extra_indent
      endif
    endif
  endif

  return indent(v:lnum)
endfunction
