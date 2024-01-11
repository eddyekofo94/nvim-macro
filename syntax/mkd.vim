" Vim syntax file
" Language:     Markdown
" Author:       Bekaboo <kankefengjing@gmail.com>
" Maintainer:   Bekaboo <kankefengjing@gmail.com>
" Remark:       Uses tex syntax file

if exists('b:current_syntax')
  unlet b:current_syntax
endif

" Include tex math in markdown
syn include @tex syntax/tex.vim
syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend

let b:current_syntax = 'mkd'
" vim: ts=8
