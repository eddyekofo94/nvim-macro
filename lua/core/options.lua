-- Enable faster lua loader using byte-compilation
-- https://github.com/neovim/neovim/commit/2257ade3dc2daab5ee12d27807c0b3bcf103cd29
vim.loader.enable()

local g = vim.g
local opt = vim.opt
local env = vim.env

-- stylua: ignore start
opt.colorcolumn    = '+1'
opt.cursorlineopt  = 'both'
opt.cursorline     = true
opt.foldlevelstart = 99
opt.foldtext       = ''
opt.helpheight     = 10
opt.showmode       = false
opt.mousemoveevent = true
opt.number         = true
opt.relativenumber = true
opt.ruler          = true
opt.pumheight      = 16
opt.scrolloff      = 4
opt.sidescrolloff  = 8
opt.signcolumn     = 'yes:1'
opt.splitright     = true
opt.splitbelow     = true
vim.opt.splitkeep = "cursor" -- topline/screen/cursor
vim.o.equalalways = false
opt.swapfile       = false
opt.undofile       = true
opt.wrap           = false
opt.linebreak      = true
opt.breakindent    = true
opt.smoothscroll   = true
opt.ignorecase     = true
opt.smartcase      = true
opt.conceallevel   = 2
opt.softtabstop    = 2
opt.shiftwidth     = 2
opt.expandtab      = true
opt.autoindent     = true
opt.autowriteall   = true
opt.virtualedit    = 'block'
opt.completeopt    = 'menuone'
opt.jumpoptions    = 'stack,view'

-- Use ripgrep as grep tool
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- completion
vim.opt.pumheight = 10 -- Makes popup menu smaller

vim.opt.inccommand = "split"
vim.o.history = 10000 -- Number of command-lines that are remembered

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 500

vim.opt.sessionoptions = {
  "resize",
  "winpos",
  "winsize",
  "terminal",
  "localoptions",
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}
-- stylua: ignore end

-- nvim 0.10.0 automatically enables termguicolors. When using nvim inside
-- tmux in Linux tty, where $TERM is set to 'tmux-256color' but $DISPLAY is
-- not set, termguicolors is automatically set. This is undesirable, so we
-- need to explicitly disable it in this case
-- if not g.modern_ui then
--   opt.termguicolors = false
-- end

---Restore 'shada' option and read from shada once
---@return true
local function _rshada()
  vim.cmd.set "shada&"
  vim.cmd.rshada()
  return true
end

opt.shada = ""
vim.defer_fn(_rshada, 100)
vim.api.nvim_create_autocmd("BufReadPre", { once = true, callback = _rshada })

-- Recognize numbered lists when formatting text
opt.formatoptions:append "n"

-- Cursor shape
opt.gcr = {
  "i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor",
  "i-ci:ver30-Cursor-blinkwait500-blinkon400-blinkoff300",
  "n-v:block-Curosr/lCursor",
  "o:hor50-Curosr/lCursor",
  "r-cr:hor20-Curosr/lCursor",
}

-- Use histogram algorithm for diffing, generates more readable diffs in
-- situations where two lines are swapped
opt.diffopt:append {
  "algorithm:histogram",
  "indent-heuristic",
}

-- Use system clipboard
opt.clipboard:append "unnamedplus"

-- Align columns in quickfix window
-- opt.quickfixtextfunc = [[v:lua.require'utils.misc'.qftf]]

-- INFO: Statuscolumn
vim.opt.statuscolumn = [[%!v:lua.require'ui.statuscolumn'.statuscolumn()]]

opt.backup = true
opt.backupdir:remove "."

-- stylua: ignore start
opt.list = true
opt.listchars = {
  tab      = '→ ',
  trail    = '·',
  precedes = "«",
  extends = "»",
  eol = "↲",
  nbsp = "░",
}

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- opt.fillchars = {
--   fold      = '·',
--   foldsep   = ' ',
--   eob       = ' ',
-- }
-- opt.fillchars:append({
--   foldopen  = '',
--   foldclose = '',
-- })

vim.cmd [[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]]

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- Netrw settings
g.netrw_banner          = 0
g.netrw_cursor          = 5
g.netrw_keepdir         = 0
g.netrw_keepj           = ''
g.netrw_list_hide       = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle       = 1
g.netrw_localcopydircmd = 'cp -r'

-- Fzf settings
g.fzf_layout = {
  window = {
    width = 0.7,
    height = 0.7,
    pos = 'center',
  },
}
env.FZF_DEFAULT_OPTS = (env.FZF_DEFAULT_OPTS or '')
  .. ' --border=sharp --margin=0 --padding=0'

-- Disable plugins shipped with neovim
g.loaded_2html_plugin      = 0
g.loaded_gzip              = 0
g.loaded_tar               = 0
g.loaded_tarPlugin         = 0
g.loaded_tutor_mode_plugin = 0
g.loaded_zip               = 0
g.loaded_zipPlugin         = 0
-- stylua: ignore end

---Lazy-load runtime files
---@param runtime string
---@param flag string
---@param event string|string[]
local function _load(runtime, flag, event)
  if not g[flag] then
    g[flag] = 0
    vim.api.nvim_create_autocmd(event, {
      once = true,
      callback = function()
        g[flag] = nil
        vim.cmd.runtime(runtime)
        return true
      end,
    })
  end
end

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  once = true,
  callback = function()
    require "ui.highlights"
  end,
})

local highlighturl_group = vim.api.nvim_create_augroup("highlighturl", { clear = true })
vim.api.nvim_set_hl(0, "HighlightURL", { default = true, underline = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = highlighturl_group,
  desc = "Set up HighlightURL hlgroup",
  callback = function()
    vim.api.nvim_set_hl(0, "HighlightURL", { default = true, underline = true })
  end,
})
vim.api.nvim_create_autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
  group = highlighturl_group,
  desc = "Highlight URLs",
  callback = function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      require("utils.general").set_url_match(win)
    end
  end,
})

_load("plugin/rplugin.vim", "loaded_remote_plugins", "FileType")
_load("provider/python3.vim", "loaded_python3_provider", "FileType")
