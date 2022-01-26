-------------------------------------------------------------------------------
-- OPTIONS --------------------------------------------------------------------
-------------------------------------------------------------------------------
local o = vim.o
local g = vim.g
local lsp = vim.lsp
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

execute                     -- Underline bad spellings
[[
hi clear SpellBad
hi SpellBad cterm=undercurl, gui=undercurl
]]
execute                     -- Define autocmd to override colorscheme settings
[[
augroup SpellBadStyle
  autocmd!
  au ColorScheme * hi clear SpellBad
  au ColorScheme * hi SpellBad cterm=undercurl, gui=undercurl
augroup END
]]

execute [[ set signcolumn=auto:1-2 ]]   -- For gitgutter & LSP diagnostic

execute [[ highlight Pmenu ctermbg=gray guibg=gray ]]

o.updatetime = 100  -- (ms)
o.swapfile = false

-- Default border style of floating windows
local border = {
      {'┌', 'FloatBorder'},
      {'─', 'FloatBorder'},
      {'┐', 'FloatBorder'},
      {'│', 'FloatBorder'},
      {'┘', 'FloatBorder'},
      {'─', 'FloatBorder'},
      {'└', 'FloatBorder'},
      {'│', 'FloatBorder'},
}
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- -- Communication between Neovim in WSL & system clipboard
-- if vim.fn.has('wsl') then
--   execute [[
--     augroup Yank
--       autocmd!
--       autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe', @")
--     augroup END
--   ]]
-- end

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

-- Excludes characters that are in the parenthesis
-- and are preceded by a capitalized letter
execute [[ autocmd VimEnter * syn match myExCapitalWords +\<\w*[A-Z]\S*\>+ contains=@NoSpell ]]
-- Exclude capitalized words and capitalized words + 's'
execute [[ autocmd VimEnter * syn match myExCapitalWords +\<[A-Z]\w*\>+ contains=@NoSpell ]]
execute [[ autocmd VimEnter * syn match myExCapitalWords +\<\w*[A-Z]\K*\>\|'s+ contains=@NoSpell ]]

-- End of Spell check ----------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LSP options -----------------------------------------------------------------
lsp.handlers["textDocument/publishDiagnostics"] =
  lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Disable underline, it's very annoying
    underline = false,
    -- Enable virtual text, override spacing to 4
    virtual_text = {spacing = 4},
    signs = true,
    update_in_insert = false
  })
-- End of LSP options ----------------------------------------------------------
--------------------------------------------------------------------------------
