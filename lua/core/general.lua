-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

local g = vim.g
local opt = vim.opt

g.has_ui = #vim.api.nvim_list_uis() > 0
g.modern_ui = g.has_ui and vim.env.DISPLAY ~= nil

-- stylua: ignore start
opt.colorcolumn    = '80'
opt.foldlevelstart = 99
opt.helpheight     = 10
opt.showmode       = false
opt.mousemoveevent = true
opt.number         = true
opt.ruler          = true
opt.pumheight      = 16
opt.scrolloff      = 4
opt.sidescrolloff  = 8
opt.sidescroll     = 0
opt.signcolumn     = 'yes:1'
opt.splitright     = true
opt.splitbelow     = true
opt.swapfile       = false
opt.undofile       = true
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.smoothscroll   = true
opt.conceallevel   = 2
opt.autowriteall   = true
opt.virtualedit    = 'block'
opt.completeopt    = 'menuone'
-- stylua: ignore end

if g.modern_ui then
  opt.cursorline = true
end

-- Recognize numbered lists when formatting text
opt.formatoptions:append('n')

-- Font for GUI
opt.guifont = 'JetbrainsMono NF ExtraLight:h13'

-- Cursor shape
opt.gcr = {
  'i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor',
  'n-v:block-Curosr/lCursor',
  'o:hor50-Curosr/lCursor',
  'r-cr:hor20-Curosr/lCursor',
}

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
  trail    = '·',
}
opt.fillchars = {
  fold      = '·',
  foldsep   = ' ',
  eob       = ' ',
}
if g.modern_ui then
  opt.listchars:append({ nbsp = '␣' })
  opt.fillchars:append({
    foldopen  = '',
    foldclose = '',
    diff      = '╱',
  })
end

opt.ts          = 4
opt.softtabstop = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smartindent = true
opt.autoindent  = true

opt.ignorecase  = true
opt.smartcase   = true

opt.spellcapcheck = ''
opt.spelllang     = 'en,cjk'
opt.spelloptions  = 'camel'
opt.spellsuggest  = 'best,9'

-- netrw settings
g.netrw_banner          = 0
g.netrw_cursor          = 5
g.netrw_keepdir         = 0
g.netrw_keepj           = ''
g.netrw_list_hide       = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle       = 1
g.netrw_localcopydircmd = 'cp -r'

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
