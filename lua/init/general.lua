-------------------------------------------------------------------------------
-- OPTIONS --------------------------------------------------------------------
-------------------------------------------------------------------------------
local o = vim.o
local g = vim.g
local lsp = vim.lsp
local execute = vim.cmd

-- Appearance & behavior
o.eb = false
o.vb = true
o.relativenumber = true
o.number = true
o.ruler = true
o.scrolloff = 8
o.wrap = false
o.termguicolors = false     -- Default GUI colors are too vivid
execute                     -- Underline bad spellings
[[
hi clear SpellBad
hi SpellBad cterm=undercurl
]]
execute
[[
highlight OverLength ctermfg=red guibg=#592929
match OverLength /\%81v.*/
]]
execute [[ highlight Pmenu ctermbg=gray guibg=gray ]]
execute                     -- Underline trailing white spaces
[[
highlight TrailingWhiteSpace cterm=underline guibg=#ddc7a1
match TrailingWhiteSpace /\s\+$/
]]
o.updatetime = 100  -- (ms)
o.swapfile = false

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
o.spellcapcheck = ''
o.spelloptions = 'camel'
-- Excludes characters that are in the parenthesis
-- and are preceded by a capitalized letter
execute [[ syn match myExCapitalWords +\<\w*[A-Z]\S*\>+ contains=@NoSpell ]]
-- Exclude capitalized words and capitalized words + 's'
execute [[ syn match myExCapitalWords +\<[A-Z]\w*\>+ contains=@NoSpell ]]
execute [[ syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell ]]


-- LSP options
lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Disable underline, it's very annoying
    underline = false,
    -- Enable virtual text, override spacing to 4
    virtual_text = {spacing = 4},
    signs = true,
    update_in_insert = false
  })
