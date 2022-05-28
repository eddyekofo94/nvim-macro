-------------------------------------------------------------------------------
-- OPTIONS --------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Appearance & behavior ------------------------------------------------------
vim.o.eb = false
vim.o.vb = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.ruler = true
vim.o.scrolloff = 8
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.pumheight = 16
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.undofile = true
vim.o.mouse = 'a'
vim.o.laststatus = 3 -- Global statusline, for neovim >= 0.7.0
vim.o.foldlevelstart = 99 -- Always start editing with no fold closed
vim.o.signcolumn = 2 -- For gitgutter & LSP diagnostic
vim.o.updatetime = 10 -- (ms)
vim.o.swapfile = false

vim.opt.list = true
vim.opt.listchars = {
  tab = '──•',
  extends = '►',
  precedes = '◄',
  nbsp = '⌴',
  trail = '·',
  lead = '·',
  multispace = '·'
}

-- Extra settings to show spaces hiding in tabs
vim.api.nvim_create_autocmd(
  { 'VimEnter', 'WinNew' },
  {
    pattern = '*',
    callback = function()
      vim.fn.matchadd('Conceal', [[\zs\ [ ]\@!\ze\t\+]], 0, -1, { conceal = '·' })
      vim.fn.matchadd('Conceal', [[\t\+\zs\ [ ]\@!]], 0, -1, { conceal = '·' })
      vim.o.conceallevel = 2
      vim.o.concealcursor = 'nic'
    end
  }
)

-- Disable number, relativenumber, and spell check in the built-in terminal
vim.api.nvim_create_autocmd(
  { 'TermOpen' },
  {
    buffer = 0,
    callback = function()
      vim.wo.spell = false
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.scrolloff = 0
    end
  }
)

-- Highlight the selection on yank
vim.api.nvim_create_autocmd(
  { 'TextYankPost' },
  {
    pattern = '*',
    callback = function()
      vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
    end
  }
)

-- Autosave on focus change
vim.api.nvim_create_autocmd(
  { 'BufLeave', 'WinLeave', 'FocusLost' },
  {
    pattern = '*',
    command = 'silent! wall',
    nested = true
  }
)

-- Jump to last accessed window on closing the current one
_G.win_close_jmp = function()
  -- Exclude floating windows
  if '' ~= vim.api.nvim_win_get_config(0).relative then return end
  -- Record the window we jump from (previous) and to (current)
  if nil == vim.t.winid_rec then
    vim.t.winid_rec = { prev = vim.fn.win_getid(), current = vim.fn.win_getid() }
  else
    vim.t.winid_rec = { prev = vim.t.winid_rec.current, current = vim.fn.win_getid() }
  end
  -- Loop through all windows to check if the previous one has been closed
  for winnr = 1, vim.fn.winnr('$') do
    if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
      return -- Return if previous window is not closed
    end
  end
  vim.cmd [[ wincmd p ]]
end

vim.cmd [[ autocmd VimEnter,WinEnter * lua win_close_jmp() ]]

-- Last-position-jump
vim.cmd
[[
  autocmd BufRead * autocmd FileType <buffer> ++once
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1
    \ && line("'\"") <= line("$") | exe 'normal! g`"' | endif
]]
-- End of Appearance & Behaviour -----------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Indentation settings --------------------------------------------------------
vim.o.ts = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
-- End of Indentation settings -------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Searching -------------------------------------------------------------------
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.keymap.set('n', '\\', '<cmd>set hlsearch!<CR>', { noremap = true })
vim.keymap.set('n', '/', '/<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '?', '?<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '*', '*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '#', '#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g*', 'g*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g#', 'g#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'n', 'n<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'N', 'N<cmd>set hlsearch<CR>', { noremap = true })
vim.api.nvim_create_autocmd(
  { 'InsertEnter' },
  {
    pattern = '*',
    command = 'set nohlsearch'
  }
)
-- End of Searching ------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Spell check (terrible, looking for alternatives...) -------------------------
vim.o.spell = true
vim.o.spelllang = 'en,cjk'
vim.o.spellsuggest = 'best, 9'
vim.o.spellcapcheck = ''
vim.o.spelloptions = 'camel'
vim.api.nvim_create_autocmd(
  { 'ColorScheme', 'VimEnter' },
  {
    pattern = '*',
    command = 'hi clear SpellBad | hi SpellBad cterm=undercurl, gui=undercurl',
    group = 'SpellBadStyle'
  }
)
-- End of Spell check ----------------------------------------------------------
--------------------------------------------------------------------------------
