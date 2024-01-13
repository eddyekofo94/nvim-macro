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

" Define markdown groups
syn match  mkdLineBreak /  \+$/
syn region mkdCode      matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/                     end=/`/                          concealends
syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/   end=/``/                         concealends
syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/^\s*\z(`\{3,}\)[^`]*$/                       end=/^\s*\z1`*\s*$/              concealends
syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/                  end=/\(\([^\\]\|^\)\\\)\@<!\~\~/ concealends
syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/      end=/^\s*\z1\~*\s*$/             concealends
syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start="<pre\(\|\_s[^>]*\)\\\@<!>"                   end="</pre>"                     concealends
syn region mkdCodeBlock matchgroup=mkdCodeDelimiter start="<code\(\|\_s[^>]*\)\\\@<!>"                  end="</code>"                    concealends
syn match  mkdCodeBlock /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/
syn match  mkdCodeBlock /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/
syn match  mkdCodeBlock /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained

hi link mkdCode          markdownCode
hi link mkdCodeBlock     markdownCodeBlock
hi link mkdCodeDelimiter markdownCodeDelimiter
hi link mkdLineBreak     NonText

let b:current_syntax = 'mkd'
" vim: ts=8
