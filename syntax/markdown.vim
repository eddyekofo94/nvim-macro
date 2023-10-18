if exists('b:current_syntax')
  unlet b:current_syntax
endif

runtime! syntax/mkd.vim
let b:current_syntax = 'mkd'
