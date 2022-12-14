local opt = vim.opt
local g = vim.g

opt.eb = false
opt.vb = true
opt.relativenumber = true
opt.number = true
opt.ruler = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.wrap = false
opt.termguicolors = true
opt.pumheight = 16
opt.cursorline = true
opt.undofile = true
opt.mouse = 'a'
opt.showtabline = 0
opt.laststatus = 3        -- Global status line, for neovim >= 0.7.0
opt.foldlevelstart = 99   -- Always start editing with no fold closed
opt.signcolumn = 'auto'   -- For gitgutter & LSP diagnostic
opt.updatetime = 10       -- (ms)
opt.swapfile = false
opt.guifont = 'FiraCode Nerd Font:h12'
-- opt.pumblend = 25
-- opt.winblend = 25

opt.backup = true
opt.backupdir = vim.fn.expand('~/.local/share/nvim/backup//')

opt.list = true
opt.listchars = {
  tab = '→ ',
  extends = '…',
  precedes = '…',
  nbsp = '⌴',
  trail = '·',
  lead = '·',
  multispace = '·'
}
-- Extra settings to show spaces hiding in tabs
vim.fn.matchadd('NonText', [[\zs\ [ ]\@!\ze\t\+]], 0, -1, { conceal = '·' })
vim.fn.matchadd('NonText', [[\t\+\zs\ [ ]\@!]], 0, -1, { conceal = '·' })
opt.conceallevel = 2

opt.ts = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

-- disable plugins shipped with neovim
g.loaded_gzip = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_matchit = 1
g.loaded_2html_plugin = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1

-- colorscheme
vim.cmd('colorscheme nvim-falcon')

-- automatically set and unset hlsearch
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    vim.opt.hlsearch = vim.tbl_contains({ 'n', 'N', '*', '#', '?', '/' },
      vim.fn.keytrans(char))
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))
