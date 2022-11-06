vim.opt.eb = false
vim.opt.vb = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.ruler = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.pumheight = 16
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.undofile = true
vim.opt.mouse = 'a'
vim.opt.laststatus = 3          -- Global status line, for neovim >= 0.7.0
vim.opt.foldlevelstart = 99     -- Always start editing with no fold closed
vim.opt.signcolumn = 'auto'     -- For gitgutter & LSP diagnostic
vim.opt.updatetime = 10         -- (ms)
vim.opt.swapfile = false
vim.opt.guifont = 'FiraCode Nerd Font:h12'
-- vim.opt.pumblend = 25
-- vim.opt.winblend = 25

vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',
  extends = '►',
  precedes = '◄',
  nbsp = '⌴',
  trail = '·',
  lead = '·',
  multispace = '·'
}
-- Extra settings to show spaces hiding in tabs
vim.fn.matchadd('Conceal', [[\zs\ [ ]\@!\ze\t\+]], 0, -1, { conceal = '·' })
vim.fn.matchadd('Conceal', [[\t\+\zs\ [ ]\@!]], 0, -1, { conceal = '·' })
vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nic'

vim.opt.ts = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.spell = true
vim.opt.spelllang = 'en,cjk'
vim.opt.spellsuggest = 'best, 9'
vim.opt.spellcapcheck = ''
vim.opt.spelloptions = 'camel'

-- disable plugins shipped with neovim
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1

-- colorscheme
vim.cmd('colorscheme nvim-falcon')
