" Vim syntax file
" Language:     Markdown
" Author:       Bekaboo <kankefengjing@gmail.com>
" Maintainer:   Bekaboo <kankefengjing@gmail.com>
" Remark:       Uses tex syntax file

if exists('b:current_syntax')
  finish
endif

" Include tex math in markdown
syn include @tex syntax/tex.vim
syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend
syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend

" Define markdown groups
syn clear  markdownCode
syn clear  markdownCodeBlock
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

lua << EOF
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.api.nvim_buf_call(buf, function()
    pcall(vim.treesitter.start, buf, 'markdown')
  end)
end)
EOF

let b:current_syntax = 'markdown'
