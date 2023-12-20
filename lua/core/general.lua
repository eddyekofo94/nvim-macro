-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

local g = vim.g
local opt = vim.opt

-- stylua: ignore start
opt.cursorline     = true
opt.colorcolumn    = '80'
opt.foldlevelstart = 99
opt.helpheight     = 10
opt.showmode       = false
opt.mousemoveevent = true
opt.relativenumber = true
opt.number         = true
opt.ruler          = true
opt.pumheight      = 10
opt.scrolloff      = 4
opt.sidescrolloff  = 8
opt.sidescroll     = 0
opt.signcolumn     = 'yes:1'
opt.splitright     = true
opt.splitbelow     = true
opt.swapfile       = false
opt.termguicolors  = true
opt.undofile       = true
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.smoothscroll   = true
opt.conceallevel   = 2
opt.autowriteall   = true
opt.virtualedit    = 'block'
opt.completeopt    = 'menuone'
opt.sessionoptions = "resize,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- stylua: ignore end

-- Use ripgrep as grep tool
vim.o.grepprg = 'rg --vimgrep --no-heading'
vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'

-- Recognize numbered lists when formatting text
opt.formatoptions:append('n')

-- Font for GUI
-- opt.guifont = 'JetbrainsMono NF ExtraLight:h13'

-- Cursor shape
opt.gcr = {
  'i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor',
  'i-ci:ver30-Cursor-blinkwait500-blinkon400-blinkoff300',
  'n-v:block-Curosr/lCursor-blinkon10',
  'o:hor50-Curosr/lCursor',
  'r-cr:hor20-Curosr/lCursor',
}

-- Disable comments on next line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.opt.undodir = vim.fn.stdpath('data') .. 'undo'

vim.o.wildoptions = 'pum'

vim.cmd(
  [[highlight HighlightedyankRegion cterm=reverse gui=reverse guifg=reverse guibg=reverse]]
)

vim.cmd([[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]])

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
opt.diffopt:append('algorithm:histogram')

-- Use system clipboard
opt.clipboard:append('unnamedplus')

opt.backup = true
opt.backupdir:remove('.')

-- stylua: ignore start
opt.list = true
opt.listchars = {
  tab      = '→ ',
  nbsp     = '␣',
  trail    = '·',
}
opt.fillchars = {
  fold      = '·',
  foldopen  = '',
  foldclose = '',
  foldsep   = ' ',
  diff      = '╱',
  eob       = ' ',
}

opt.ts          = 4
opt.softtabstop = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true
opt.autoindent  = true

opt.ignorecase  = true
opt.smartcase   = true

opt.spellcapcheck = ''
opt.spelllang     = 'en'
opt.spelloptions  = 'camel'
opt.spellsuggest  = 'best,9'

-- disable plugins shipped with neovim
g.loaded_2html_plugin      = 1
g.loaded_gzip              = 1
g.loaded_matchit           = 1
g.loaded_tar               = 1
g.loaded_tarPlugin         = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimball           = 1
g.loaded_vimballPlugin     = 1
g.loaded_zip               = 1
g.loaded_zipPlugin         = 1
-- stylua: ignore end
