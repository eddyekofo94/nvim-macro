-------------------------------------------------------------------------------
-- OPTIONS --------------------------------------------------------------------
-------------------------------------------------------------------------------
local o = vim.o
local g = vim.g
local lsp = vim.lsp

-- Appearance & behavior
o.eb = false
o.vb = true
o.relativenumber = true
o.number = true
o.ruler = true
o.scrolloff = 8
o.wrap = false
o.termguicolors = true
o.colorcolumn = '80'
o.updatetime = 100  -- (ms)

-- Indentation settings
o.ts = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.autoindent = true

-- Searching
o.hlsearch = false
o.ignorecase = true
o.smartcase = true

-- Spell check (terrible, looking for alternatives...)
o.spell = true
g.spelllang = {en, cjk}
o.spellsuggest = 'best, 9'


-- Lsp options
lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Disable underline, it's very annoying
    underline = false,
    -- Enable virtual text, override spacing to 4
    virtual_text = {spacing = 4},
    signs = true,
    update_in_insert = false
  })
