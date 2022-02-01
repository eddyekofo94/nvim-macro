vim.cmd [[ colorscheme falcon ]]
vim.g.falcon_background = 0

-- Fix gitignored file icon display in nvim-tree
vim.cmd
[[ 
hi NvimTreeGitIgnored guifg=#787882 ctermfg=248
\guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
]]

-- Do not display diagnostic virtual text in italic
vim.cmd
[[
hi LspDiagnosticsVirtualTextError guifg=#9E1E00 ctermfg=124 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi LspDiagnosticsVirtualTextWarning guifg=#BC8F3F ctermfg=137 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi LspDiagnosticsVirtualTextHint guifg=#847B73 ctermfg=8 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi LspDiagnosticsVirtualTextInformation guifg=#787882 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticVirtualTextError guifg=#9E1E00 ctermfg=124 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticVirtualTextWarn guifg=#BC8F3F ctermfg=137 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticVirtualTextHint guifg=#847B73 ctermfg=8 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
hi DiagnosticVirtualTextInfo guifg=#787882 ctermfg=243 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
]]

-- Colorize borders
vim.cmd [[highlight NormalFloat guibg=NONE ctermbg=NONE]]
vim.cmd [[highlight FloatBorder guifg=#ff761a guibg=NONE ctermfg=1 ctermbg=NONE]]

-- Colorscheme for telescope
vim.cmd
[[
hi TelescopeBorder ctermfg=1 ctermbg=NONE guifg=#FF761A guibg=NONE
hi TelescopeNormal ctermbg=NONE guibg=NONE
hi TelescopePreviewNormal ctermbg=NONE guibg=NONE
hi TelescopeResultNormal ctermbg=NONE guibg=NONE
hi TelescopeTitle ctermbg=NONE guibg=NONE
hi TelescopePreviewTitle ctermbg=NONE guibg=NONE
hi TelescopeResultTitle ctermbg=NONE guibg=NONE
hi TelescopeMatching ctermfg=green ctermbg=NONE guifg=#7FBF00 guibg=NONE
hi TelescopePromptPrefix ctermbg=NONE guibg=NONE
hi TelescopeSelection ctermbg=NONE guibg=NONE
hi TelescopeSelectionCaret ctermbg=NONE guibg=NONE
hi TelescopeMultiSelection ctermbg=NONE guibg=NONE
hi TelescopeMultiIcon ctermbg=NONE guibg=NONE
]]

-- Override barbar default highlight
vim.cmd
[[
hi BufferCurrent guifg=#EFEFEF ctermfg=white guibg=NONE ctermbg=NONE
hi BufferCurrentMod guifg=#FF761A ctermfg=brown guibg=NONE ctermbg=NONE
hi BufferVisible guifg=#EFEFEF ctermfg=white guibg=#212127
hi BufferVisibleMod guifg=#FF761A ctermfg=brown guibg=#212127
hi BufferVisibleSign guibg=#212127
hi BufferVisibleTarget guibg=#212127
hi BufferVisibleIndex guibg=#212127
hi BufferInactiveMod guifg=#911E00 ctermfg=red
]]

-- Override highlight color for git change (`gitsigns.nvim`)
vim.cmd [[ hi GitSignsChange guifg=#AA00F5 ctermfg=darkmagenta ]]

-- Override highlight for `nvim-tree`
vim.cmd [[ hi NvimTreeGitDirty guifg=#AA00F5 ctermfg=darkmagenta ]]
vim.cmd [[ hi NvimTreeOpenedFile guifg=#EFEFEF gui=NONE ctermfg=white cterm=NONE ]]
