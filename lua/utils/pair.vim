inoremap (                      ()<esc>i
inoremap [                      []<esc>i
inoremap {                      {}<esc>i
inoremap "                      ""<esc>i
inoremap '                      ''<esc>i

" Auto indentation in paired brackets/parenthesis/tags, etc.
inoremap <CR>                   <C-r>=PairedIndent()<CR>

" Auto delete paired brackets/paranthesis/tags, etc.
inoremap <BackSpace>            <C-r>=PairedDelete()<CR>

" Jump out brackets by tab:
" inoremap <Tab>                  <C-r>=PairedJmpOut()<CR>


"" Functions:
func PairedIndent ()
    let c = getline('.')[col('.') - 1]
    let p = getline('.')[col('.') - 2]
    if ')' == c && '(' == p || ']' == c && '[' == p || '}' == c && '{' == p || 
        \'>' == c && '<' == p || '"' == c && '"' == p || "'" == c && '"' == p
        return "\<cr>\<esc>O"
    endif
    if ')' == c || ']' == c || '}' == c || '>' == c || '"' == c || "'" == c
        let command = printf("\<esc>di%si\<cr>\<esc>Pli\<cr>\<esc>k>>A", c)
        return command
    endif
    return "\<cr>"
endfunc

func PairedDelete ()
    let c = getline('.')[col('.') - 1]
    let p = getline('.')[col('.') - 2]
    if ')' == c && '(' == p || ']' == c && '[' == p || '}' == c && '{' == p || 
        \'>' == c && '<' == p || '"' == c && '"' == p || "'" == c && "'" == p
        return "\<backspace>\<delete>"
    endif
    return "\<backspace>"
endfunc

func PairedJmpOut ()
    let c = getline('.')[col('.') - 1]
    if ')' == c || ']' == c || '}' == c || '>' == c || '"' == c || "'" == c
        return "\<esc>la"
    endif
    return "\t"
endfunc
