-------------------------------------------------------------------------------
-- General Options ------------------------------------------------------------
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
vim.o.laststatus = 3          -- Global status line, for neovim >= 0.7.0
vim.o.foldlevelstart = 99     -- Always start editing with no fold closed
vim.o.signcolumn = 'auto:1-2' -- For gitgutter & LSP diagnostic
vim.o.updatetime = 10         -- (ms)
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
-- End of General Options -----------------------------------------------------
-------------------------------------------------------------------------------


-- Behavior & Autocommands ----------------------------------------------------
-------------------------------------------------------------------------------

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
vim.api.nvim_create_autocmd(
  { 'VimEnter', 'WinEnter' },
  {
    pattern = '*',
    callback = function()
      require('utils.funcs').win_close_jmp()
    end
  }
)

-- Last-position-jump
vim.api.nvim_create_autocmd(
  { 'BufReadPost' },
  {
    pattern = '*',
    callback = function()
      require('utils.funcs').last_pos_jmp()
    end
  }
)
-- End of Behavior & Autocommands ---------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Indentation settings -------------------------------------------------------
vim.o.ts = 4
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
-- End of Indentation settings ------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Searching ------------------------------------------------------------------
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
  { 'InsertEnter' }, {
  pattern = '*',
  command = 'set nohlsearch'
}
)
-- End of Searching -----------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Spell check (terrible, looking for alternatives...) ------------------------
vim.o.spell = true
vim.o.spelllang = 'en,cjk'
vim.o.spellsuggest = 'best, 9'
vim.o.spellcapcheck = ''
vim.o.spelloptions = 'camel'
vim.api.nvim_create_autocmd(
  { 'ColorScheme', 'VimEnter' },
  {
    pattern = '*',
    command = 'hi clear SpellBad | hi SpellBad cterm=undercurl gui=undercurl'
  }
)
-- End of Spell check ---------------------------------------------------------
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Keybindings ----------------------------------------------------------------

-- Map leader key to space
vim.keymap.set('n', '<Space>', '', {})
vim.g.mapleader = ' '

-- Map esc key
vim.keymap.set('i', 'jj', '<esc>', { noremap = true })

-- Exit from term mode
vim.keymap.set('t', '\\<C-\\>', '<C-\\><C-n>', { noremap = true })

-- Toggle hlsearch
vim.keymap.set('n', '\\', '<cmd>set hlsearch!<CR>', { noremap = true })
vim.keymap.set('n', '/', '/<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '?', '?<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '*', '*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', '#', '#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g*', 'g*<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'g#', 'g#<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'n', 'n<cmd>set hlsearch<CR>', { noremap = true })
vim.keymap.set('n', 'N', 'N<cmd>set hlsearch<CR>', { noremap = true })

-- Multi-window operations
vim.keymap.set('n', '<M-w>', '<C-w><C-w>', { noremap = true })
vim.keymap.set('n', '<M-h>', '<C-w><C-h>', { noremap = true })
vim.keymap.set('n', '<M-j>', '<C-w><C-j>', { noremap = true })
vim.keymap.set('n', '<M-k>', '<C-w><C-k>', { noremap = true })
vim.keymap.set('n', '<M-l>', '<C-w><C-l>', { noremap = true })
vim.keymap.set('n', '<M-W>', '<C-w>W', { noremap = true })
vim.keymap.set('n', '<M-H>', '<C-w>H', { noremap = true })
vim.keymap.set('n', '<M-J>', '<C-w>J', { noremap = true })
vim.keymap.set('n', '<M-K>', '<C-w>K', { noremap = true })
vim.keymap.set('n', '<M-L>', '<C-w>L', { noremap = true })
vim.keymap.set('n', '<M-=>', '<C-w>=', { noremap = true })
vim.keymap.set('n', '<M-->', '<C-w>-', { noremap = true })
vim.keymap.set('n', '<M-+>', '<C-w>+', { noremap = true })
vim.keymap.set('n', '<M-_>', '<C-w>_', { noremap = true })
vim.keymap.set('n', '<M-|>', '<C-w>|', { noremap = true })
vim.keymap.set('n', '<M-,>', '<C-w><', { noremap = true })
vim.keymap.set('n', '<M-.>', '<C-w>>', { noremap = true })
vim.keymap.set('n', '<M-p>', '<C-w>p', { noremap = true })
vim.keymap.set('n', '<M-r>', '<C-w>r', { noremap = true })
vim.keymap.set('n', '<M-v>', '<C-w>v', { noremap = true })
vim.keymap.set('n', '<M-s>', '<C-w>s', { noremap = true })
vim.keymap.set('n', '<M-x>', '<C-w>x', { noremap = true })
vim.keymap.set('n', '<M-z>', '<C-w>z', { noremap = true })
vim.keymap.set('n', '<M-c>', '<C-w>c', { noremap = true }) -- Close current window
vim.keymap.set('n', '<M-o>', '<C-w>o', { noremap = true }) -- Close all other windows
vim.keymap.set('n', '<M-t>', '<C-w>t', { noremap = true })
vim.keymap.set('n', '<M-T>', '<C-w>T', { noremap = true })
vim.keymap.set('n', '<M-]>', '<C-w>]', { noremap = true })
vim.keymap.set('n', '<M-^>', '<C-w>^', { noremap = true })
vim.keymap.set('n', '<M-b>', '<C-w>b', { noremap = true })
vim.keymap.set('n', '<M-d>', '<C-w>d', { noremap = true })
vim.keymap.set('n', '<M-f>', '<C-w>f', { noremap = true })
vim.keymap.set('n', '<M-g><M-]>', '<C-w>g<C-]>', { noremap = true })
vim.keymap.set('n', '<M-g>]', '<C-w>g]', { noremap = true })
vim.keymap.set('n', '<M-g>}', '<C-w>g}', { noremap = true })
vim.keymap.set('n', '<M-g>f', '<C-w>gf', { noremap = true })
vim.keymap.set('n', '<M-g>F', '<C-w>gF', { noremap = true })
vim.keymap.set('n', '<M-g>t', '<C-w>gt', { noremap = true })
vim.keymap.set('n', '<M-g>T', '<C-w>gT', { noremap = true })
vim.keymap.set('n', '<M-g><Tab>', '<C-w>g<Tab>', { noremap = true })
vim.keymap.set('n', '<M-}>', '<C-w>}', { noremap = true })

-- Close all floating windows
vim.keymap.set('n', '<M-;>',
  function()
    require('utils.funcs').close_all_floatings()
  end,
  { noremap = true }
)

-- Multi-buffer operations
vim.keymap.set('n', '<Tab>', '<cmd>bn<CR>', { noremap = true })
vim.keymap.set('n', '<S-Tab>', '<cmd>bp<CR>', { noremap = true })
-- Delete current buffer
vim.keymap.set('n', '<M-d>', '<cmd>bd<CR>', { noremap = true })
-- <Tab> / <C-i> is used to switch buffers,
-- so use <C-n> to jump to newer cursor position instead
vim.keymap.set('n', '<C-n>', '<C-i>', { noremap = true })

-- Moving in insert and command-line mode
vim.keymap.set({ 'i', 'c' }, '<M-h>', '<left>', { noremap = true })
vim.keymap.set({ 'i', 'c' }, '<M-j>', '<down>', { noremap = true })
vim.keymap.set({ 'i', 'c' }, '<M-k>', '<up>', { noremap = true })
vim.keymap.set({ 'i', 'c' }, '<M-l>', '<right>', { noremap = true })
-- End of keybindings ---------------------------------------------------------
-------------------------------------------------------------------------------
