-------------------------------------------------------------------------------
-- KEYMAPPINGS ----------------------------------------------------------------
-------------------------------------------------------------------------------
-- NOTICE: Not all keymappings are kept in this file
-- Only general keymappings are kept here
-- Plugin-specific keymappings are kept in corresponding
-- config files for that plugin

local map = vim.api.nvim_set_keymap
local g = vim.g

-- Map leader key to space
map('n', '<Space>', '', {})
g.mapleader = ' '

-- Map esc key
map('i', 'jj', '<esc>', {noremap = true})

-- Exit from term mode
map('t', '\\<C-\\>', '<C-\\><C-n>', {noremap = true})

-- Toggle hlsearch
map('n', '\\', '<cmd>set hlsearch!<CR>', {noremap = true})
map('n', '/', '/<cmd>set hlsearch<CR>', {noremap = true})
map('n', '?', '?<cmd>set hlsearch<CR>', {noremap = true})
map('n', '*', '*<cmd>set hlsearch<CR>', {noremap = true})
map('n', '#', '#<cmd>set hlsearch<CR>', {noremap = true})
map('n', 'g*', 'g*<cmd>set hlsearch<CR>', {noremap = true})
map('n', 'g#', 'g#<cmd>set hlsearch<CR>', {noremap = true})
map('n', 'n', 'n<cmd>set hlsearch<CR>', {noremap = true})
map('n', 'N', 'N<cmd>set hlsearch<CR>', {noremap = true})

-- Multi-window operations
map('n', '<M-w>', '<C-w><C-w>', {noremap = true})
map('n', '<M-h>', '<C-w><C-h>', {noremap = true})
map('n', '<M-j>', '<C-w><C-j>', {noremap = true})
map('n', '<M-k>', '<C-w><C-k>', {noremap = true})
map('n', '<M-l>', '<C-w><C-l>', {noremap = true})
map('n', '<M-W>', '<C-w>W', {noremap = true})
map('n', '<M-H>', '<C-w>H', {noremap = true})
map('n', '<M-J>', '<C-w>J', {noremap = true})
map('n', '<M-K>', '<C-w>K', {noremap = true})
map('n', '<M-L>', '<C-w>L', {noremap = true})
map('n', '<M-=>', '<C-w>=', {noremap = true})
map('n', '<M-->', '<C-w>-', {noremap = true})
map('n', '<M-+>', '<C-w>+', {noremap = true})
map('n', '<M-_>', '<C-w>_', {noremap = true})
map('n', '<M-|>', '<C-w>|', {noremap = true})
map('n', '<M-,>', '<C-w><', {noremap = true})
map('n', '<M-.>', '<C-w>>', {noremap = true})
map('n', '<M-p>', '<C-w>p', {noremap = true})
map('n', '<M-v>', '<cmd>vsplit<CR>', {noremap = true})
map('n', '<M-x>', '<cmd>split<CR>', {noremap = true})
map('n', '<M-c>', '<C-w>c', {noremap = true})   -- Close current window
map('n', '<M-C>', '<C-w>o', {noremap = true})   -- Close all other windows

-- From https://github.com/wookayin/dotfiles/commit/96d935515486f44ec361db3df8ab9ebb41ea7e40
function _G.close_all_floatings()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then         -- is_floating_window?
      vim.api.nvim_win_close(win, false)  -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format ('Closed %d windows: %s', #closed_windows,
                       vim.inspect(closed_windows)))
end

-- Close all floating windows
map('n','<M-;>', "<cmd>lua close_all_floatings()<CR>", {noremap = true})


-- Multi-buffer operations
map('n', '<Tab>', '<cmd>bn<CR>', {noremap = true})
map('n', '<S-Tab>', '<cmd>bp<CR>', {noremap = true})
map('n', '<M-d>', '<cmd>bd<CR>', {noremap = true})  -- Delete current buffer

-- Moving in insert mode
map('i', '<M-h>', '<left>', {noremap = true})
map('i', '<M-j>', '<down>', {noremap = true})
map('i', '<M-k>', '<up>', {noremap = true})
map('i', '<M-l>', '<right>', {noremap = true})

-- Termdebug mappings and autocommands
vim.cmd [[
  nnoremap <F5> <Cmd>packadd termdebug\|Termdebug<CR>
  au User TermdebugStartPre   let g:termdebug_wide=sort([float2nr(winwidth('$') * 0.4), 80, 28], 'n')[1]
  au User TermdebugStartPre   nnoremap <F4>  <Cmd>Run<CR>|
                             \nnoremap <F5>  <Cmd>Continue<CR>|
                             \nnoremap <F6>  <Cmd>Stop<CR>|
                             \nnoremap <F7>  <Cmd>Clear<CR>|
                             \nnoremap <F8>  <Cmd>Break<CR>|
                             \nnoremap <F10> <Cmd>Over<CR>|
                             \nnoremap <F11> <Cmd>Step<CR>|
                             \nnoremap <F12> <Cmd>Finish<CR>
  au User TermdebugStartPost  lua vim.api.nvim_win_set_width(0, vim.g.termdebug_wide)
  au User TermdebugStartPost  setlocal nobl|
                             \wincmd j|
                             \setlocal nobl|
                             \wincmd k|
                             \wincmd l|
                             \wincmd p
  au User TermdebugStartPost  nnoremap <buffer> <M-c> iquit<CR>|
                             \nnoremap <buffer> <M-d> iquit<CR>|
                             \nnoremap <buffer> q     iquit<CR>
  au User TermdebugStopPost   unmap    <F4>|
                             \nnoremap <F5>  <Cmd>packadd termdebug\|Termdebug<CR>|
                             \unmap    <F6>|
                             \unmap    <F7>|
                             \unmap    <F8>|
                             \unmap    <F10>|
                             \unmap    <F11>|
                             \unmap    <F12>
]]

-- -- Patch for pairing
-- execute
-- [[
-- inoremap (                      ()<left>
-- inoremap [                      []<left>
-- inoremap {                      {}<left>
-- inoremap "                      ""<left>
-- inoremap '                      ''<left>
-- inoremap `                      ``<left>
-- " For c struct definition
-- inoremap <silent>;              <C-r>=CStructDef()<CR>

-- " Auto indentation in paired brackets/parenthesis/tags, etc.
-- inoremap <silent><CR>           <C-r>=PairedIndent()<CR>

-- " Auto delete paired brackets/parenthesis/tags, etc.
-- inoremap <silent><BackSpace>    <C-r>=PairedDelete()<CR>

-- inoremap <silent><Space>        <C-r>=PairedSpace()<CR>

-- "" Functions:
-- func PairedIndent ()
--     let c = getline('.')[col('.') - 1]
--     let p = getline('.')[col('.') - 2]
--     if ')' == c && '(' == p || ']' == c && '[' == p || '}' == c && '{' == p ||
--         \"'" == c && '"' == p || '`' == c && '`' == p
--         return "\<cr>\<esc>O"
--     endif
--     if ')' == c || ']' == c || '}' == c
--         let command = printf("\<esc>di%si\<cr>\<esc>Pli\<cr>\<esc>k>>A", c)
--         return command
--     endif
--     return "\<cr>"
-- endfunc

-- func PairedDelete ()
--     let c = getline('.')[col('.') - 1]
--     let p = getline('.')[col('.') - 2]
--     let pp = getline('.')[col('.') - 3]
--     let s = getline('.')[col('.')]
--     if ')' == c && '(' == p || ']' == c && '[' == p || '}' == c && '{' == p || 
--         \'>' == c && '<' == p || '"' == c && '"' == p || "'" == c && "'" == p ||
--         \'`' == c && '`' == p
--         if ';' != s
--             return "\<backspace>\<delete>"
--         endif
--         if ';' == s && 'c' == &filetype
--             return "\<backspace>\<delete>\<delete>"
--         elseif ';' == s && 'c' != &filetype
--             return "\<backspace>\<delete>"
--         endif
--     endif
--     if ' ' == p && ' ' == c &&
--         \(')' == s && '(' == pp || ']' == s && '[' == pp || '}' == s && '{' == pp || 
--         \'>' == s && '<' == pp || '"' == s && '"' == pp || "'" == s && "'" == pp ||
--         \'`' == s && '`' == pp)
--         return "\<backspace>\<delete>"
--     endif
--     return "\<backspace>"
-- endfunc

-- func PairedSpace ()
--     let c = getline('.')[col('.') - 1]
--     let p = getline('.')[col('.') - 2]
--     if ')' == c && '(' == p || ']' == c && '[' == p || '}' == c && '{' == p
--         return "\<space>\<space>\<left>"
--     endif
--     return "\<space>"
-- endfunc

-- func CStructDef ()
--     let c = getline('.')[col('.') - 1]
--     let p = getline('.')[col('.') - 2]
--     if '}' == c && '{' == p && 'c' == &filetype
--         return "\<right>;\<left>\<left>"
--     endif
--     return ";"
-- endfunc
-- ]]
