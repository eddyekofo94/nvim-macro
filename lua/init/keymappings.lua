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
map('t', '<C-\\><C-\\>', '<C-\\><C-n>', {noremap = true})

-- Toggle hlsearch
map('n', '\\', '<cmd>set hlsearch!<CR>', {noremap = true})
map('n', '/', '<cmd>set hlsearch<CR>/', {noremap = true})
map('n', '?', '<cmd>set hlsearch<CR>?', {noremap = true})
map('n', '*', '<cmd>set hlsearch<CR>*', {noremap = true})
map('n', '#', '<cmd>set hlsearch<CR>#', {noremap = true})
map('n', 'g*', '<cmd>set hlsearch<CR>g*', {noremap = true})
map('n', 'g#', '<cmd>set hlsearch<CR>g#', {noremap = true})

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
map('n', '<M-v>', ':vsplit<CR>', {noremap = true, silent = true})
map('n', '<M-x>', ':split<CR>', {noremap = true, silent = true})
map('n', '<M-c>', '<C-w>c', {noremap = true})   -- Close current window
map('n', '<M-C>', '<C-w>o', {noremap = true})   -- Close all other windows

-- Close all floating windows
map('n','<M-;>',
    "<cmd>lua Close_all_floatings()<CR>",
    {noremap = true, silent = true})

-- From https://github.com/wookayin/dotfiles/commit/96d935515486f44ec361db3df8ab9ebb41ea7e40
function Close_all_floatings()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then         -- is_floating_window?
      vim.api.nvim_win_close(win, false)  -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format ('Closed %d windows: %s', #closed_windows,
                       vim.inspect(closed_windows)))
end


-- Multi-buffer operations
map('n', '<Tab>', ':bn<CR>', {noremap = true, silent = true})
map('n', '<S-Tab>', ':bp<CR>', {noremap = true, silent = true})
map('n', '<M-d>', ':bd<CR>', {noremap = true})  -- Delete current buffer

-- Moving in insert mode
map('i', '<M-h>', '<left>', {noremap = true})
map('i', '<M-j>', '<down>', {noremap = true})
map('i', '<M-k>', '<up>', {noremap = true})
map('i', '<M-l>', '<right>', {noremap = true})

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
