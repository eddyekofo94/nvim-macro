-------------------------------------------------------------------------------
-- OPTIONS --------------------------------------------------------------------
-------------------------------------------------------------------------------
local o = vim.o
local execute = vim.cmd


-------------------------------------------------------------------------------
-- Appearance & behavior ------------------------------------------------------
o.eb = false
o.vb = true
o.relativenumber = true
o.number = true
o.ruler = true
o.scrolloff = 8
o.wrap = false
o.termguicolors = true      -- Default GUI colors are too vivid
o.pumheight = 16

execute
[[
  set list listchars=tab:*─,extends:►,precedes:◄,lead:·,nbsp:·,trail:·
]]

-- Disable number and relativenumber in the built-in terminal
execute [[ autocmd TermOpen * setlocal nospell nonumber norelativenumber ]]

execute                     -- Underline bad spellings
[[
augroup SpellBadStyle
  autocmd!
  au ColorScheme,VimEnter * hi clear SpellBad
  au ColorScheme,VimEnter * hi SpellBad cterm=undercurl, gui=undercurl
augroup END
]]

execute [[ autocmd InsertEnter,TermEnter * set nohlsearch ]]

execute [[ set signcolumn=auto:1-2 ]]   -- For gitgutter & LSP diagnostic

execute [[ highlight Pmenu ctermbg=gray guibg=gray ]]

o.updatetime = 10   -- (ms)
o.swapfile = false

-- if vim.fn.has('wsl') then
--   execute [[
--     augroup Yank
--       autocmd!
--       autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe', @")
--     augroup END
--   ]]
-- end

-- Autosave on focus change
execute [[ autocmd BufLeave,WinLeave,FocusLost * silent! wall ]]

-- Last-position-jump
execute
[[
  autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1
    \ && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]]
-- End of Appearance & Behaviour -----------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Indentation settings --------------------------------------------------------
o.ts = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true
-- End of Indentation settings -------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Searching -------------------------------------------------------------------
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
-- End of Searching ------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Spell check (terrible, looking for alternatives...) -------------------------
o.spell = true
execute [[ set spelllang=en,cjk ]]
o.spellsuggest = 'best, 9'
o.spellcapcheck = ''
o.spelloptions = 'camel'
-- End of Spell check ----------------------------------------------------------
--------------------------------------------------------------------------------
