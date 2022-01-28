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
