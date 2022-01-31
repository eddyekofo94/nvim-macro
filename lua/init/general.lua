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

execute                     -- Underline bad spellings
[[
augroup SpellBadStyle
  autocmd!
  au ColorScheme,VimEnter * hi clear SpellBad
  au ColorScheme,VimEnter * hi SpellBad cterm=undercurl, gui=undercurl
augroup END
]]

execute [[ set fillchars-=vert:\| | set fillchars+=vert:\▎ ]]

execute [[ set signcolumn=auto:1-2 ]]   -- For gitgutter & LSP diagnostic

execute [[ highlight Pmenu ctermbg=gray guibg=gray ]]

o.updatetime = 100  -- (ms)
o.swapfile = false

-- -- Communication between Neovim in WSL & system clipboard
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

-- Excludes characters that are in the parenthesis
-- and are preceded by a capitalized letter
execute [[ autocmd VimEnter * syn match myExCapitalWords +\<\w*[A-Z]\S*\>+ contains=@NoSpell ]]
-- Exclude capitalized words and capitalized words + 's'
execute [[ autocmd VimEnter * syn match myExCapitalWords +\<[A-Z]\w*\>+ contains=@NoSpell ]]
execute [[ autocmd VimEnter * syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell ]]
-- End of Spell check ----------------------------------------------------------
--------------------------------------------------------------------------------
