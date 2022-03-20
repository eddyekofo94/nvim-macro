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
o.cursorline = true
o.cursorlineopt = 'number'
o.undofile = true
o.mouse = 'a'
o.laststatus = 3            -- Global statusline, for neovim >= 0.7.0

execute
[[
  set list listchars=tab:→\ ,
          \extends:►,
          \precedes:◄,
          \nbsp:⌴,
          \trail:·,
          \lead:·,
          \multispace:·
]]

-- Extra settings to show spaces hiding in tabs
execute [[
  au VimEnter,WinNew *
    \ call matchadd('Conceal', '\zs\ [ ]\@!\ze\t\+', 0, -1, {'conceal': '·'}) |
    \ call matchadd('Conceal', '\t\+\zs\ [ ]\@!', 0, -1, {'conceal': '·'}) |
    \ set conceallevel=2 concealcursor=nic
]]

-- Disable number and relativenumber in the built-in terminal
execute [[ autocmd TermOpen * setlocal nospell nonumber norelativenumber scrolloff=0 ]]

execute                     -- Underline bad spellings
[[
augroup SpellBadStyle
  autocmd!
  au ColorScheme,VimEnter * hi clear SpellBad
  au ColorScheme,VimEnter * hi SpellBad cterm=undercurl, gui=undercurl
augroup END
]]

execute [[ autocmd InsertEnter * set nohlsearch ]]

execute [[ set signcolumn=auto:1-2 ]]   -- For gitgutter & LSP diagnostic

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

-- Highlight the selection on yank
execute [[ au TextYankPost * silent
         \ lua vim.highlight.on_yank({higroup = 'Visual', timeout = 300}) ]]

-- Autosave on focus change
execute [[ autocmd BufLeave,WinLeave,FocusLost * nested silent! wall ]]


-- Jump to last accessed window on closing the current one
_G.win_close_jmp = function ()
  -- Exclude floating windows
  if '' ~= vim.api.nvim_win_get_config(0).relative then return end
  -- Record the window we jump from (previous) and to (current)
  if nil == vim.t.winid_rec then
    vim.t.winid_rec = { prev = vim.fn.win_getid(), current = vim.fn.win_getid() }
  else
    vim.t.winid_rec = { prev = vim.t.winid_rec.current, current = vim.fn.win_getid() }
  end

  -- Loop through all windows to check if the previous one has been closed
  for winnr=1,vim.fn.winnr('$') do
    if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
      return        -- Return if previous window is not closed
    end
  end

  vim.cmd [[ wincmd p ]]
end

execute [[ autocmd VimEnter,WinEnter * lua win_close_jmp() ]]

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
