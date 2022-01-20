-------------------------------------------------------------------------------
-- KEYMAPPINGS ----------------------------------------------------------------
-------------------------------------------------------------------------------
-- NOTICE: Not all keymappings are kept in this file
-- Only general keymappings are kept here
-- Plugin-specific keymappings are kept in corresponding
-- config files for that plugin

local map = vim.api.nvim_set_keymap
local g = vim.g
local execute = vim.cmd

-- Map leader key to space
map('n', '<Space>', '', {})
g.mapleader = ' '

-- Map esc key
map('i', 'jj', '<esc>', {noremap = true})

-- Exit from term mode
map('t', '<esc>', '<C-\\><C-n>', {noremap = true})

-- Yank/delete/change all
map('n', 'yA', 'ggyG', {noremap = true})
map('n', 'dA', 'ggdG', {noremap = true})
map('n', 'cA', 'ggcG', {noremap = true})
-- Visual select all
map('v', 'A', '<esc>ggvG', {noremap = true})

-- Multi-window operations
map('n', '<M-w>', '<C-w><C-w>', {noremap = true})
map('n', '<M-h>', '<C-w><C-h>', {noremap = true})
map('n', '<M-j>', '<C-w><C-j>', {noremap = true})
map('n', '<M-k>', '<C-w><C-k>', {noremap = true})
map('n', '<M-l>', '<C-w><C-l>', {noremap = true})
map('n', '<M-=>', '<C-w>=', {noremap = true})
map('n', '<M-->', '<C-w>-', {noremap = true})
map('n', '<M-+>', '<C-w>+', {noremap = true})
map('n', '<M-_>', '<C-w>_', {noremap = true})
map('n', '<M-|>', '<C-w>|', {noremap = true})
map('n', '<M-,>', '<C-w><', {noremap = true})
map('n', '<M-.>', '<C-w>>', {noremap = true})
map('n', '<M-v>', ':vsplit<CR>', {noremap = true, silent = true})
map('n', '<M-x>', ':split<CR>', {noremap = true, silent = true})
map('n', '<M-q>', '<C-w>c', {noremap = true})   -- Quit current window
map('n', '<M-o>', '<C-w>o', {noremap = true})   -- Close all other windows

-- Multi-buffer operations
map('n', '<Tab>', ':bn<CR>', {noremap = true, silent = true})
map('n', '<S-Tab>', ':bp<CR>', {noremap = true, silent = true})
map('n', '<M-d>', ':bd<CR>', {noremap = true})  -- Delete current buffer

-- Moving in insert mode
map('i', '<M-h>', '<left>', {noremap = true})
map('i', '<M-j>', '<down>', {noremap = true})
map('i', '<M-k>', '<up>', {noremap = true})
map('i', '<M-l>', '<right>', {noremap = true})

-- Patch for pairing
execute
[[
inoremap (                      ()<left>
inoremap [                      []<left>
inoremap {                      {}<left>
inoremap "                      ""<left>
inoremap '                      ''<left>
inoremap `                      ``<left>

" Auto indentation in paired brackets/parenthesis/tags, etc.
inoremap <CR>                   <C-r>=PairedIndent()<CR>

" Auto delete paired brackets/paranthesis/tags, etc.
inoremap <BackSpace>            <C-r>=PairedDelete()<CR>

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

" func PairedJmpOut ()
"   let c = getline('.')[col('.') - 1]
"   if ')' == c || ']' == c || '}' == c || '>' == c || '"' == c || "'" == c
"       return "\<esc>la"
"   endif
"   return "\t"
" endfunc
]]
