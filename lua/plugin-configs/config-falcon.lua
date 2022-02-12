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

-- Do not display cmp fuzzy-finding matches in italic
vim.cmd [[ hi CmpItemAbbrMatchFuzzy cterm=NONE gui=NONE ]]

-- Highlights for cmp kind icons
vim.cmd
[[
hi      CmpItemKindText        ctermfg=243 guifg=#99A4BC
hi link CmpItemKindMethod      Function
hi link CmpItemKindFunction    Function
hi link CmpItemKindConstructor TSConstructor
hi      CmpItemKindField       ctermfg=97  guifg=#BB99E3
hi      CmpItemKindProperty    ctermfg=97  guifg=#BB99E3
hi      CmpItemKindVariable    ctermfg=248 guifg=#5C9EA1
hi      CmpItemKindReference   ctermfg=248 guifg=#5C9EA1
hi      CmpItemKindModule      ctermfg=92  guifg=#635196
hi      CmpItemKindEnum        ctermfg=209 guifg=#B24D36
hi      CmpItemKindEnumMember  ctermfg=209 guifg=#B24D36
hi link CmpItemKindKeyword     Operator
hi link CmpItemKindOperator    Operator
hi      CmpItemKindSnippet     ctermfg=7   guifg=#C1E587
hi      CmpItemKindColor       ctermfg=199 guifg=#F0989A
hi      CmpItemKindConstant    ctermfg=137 guifg=#FFE8C8
hi      CmpItemKindValue       ctermfg=15  guifg=#EFEFEF
hi      CmpItemKindClass       ctermfg=68  guifg=#7295F5
hi      CmpItemKindStruct      ctermfg=68  guifg=#7295F5
hi      CmpItemKindEvent       ctermfg=67  guifg=#FFC552
hi      CmpItemKindInterface   ctermfg=67  guifg=#BFDAFF
hi link CmpItemKindFile        DevIconDefault
hi link CmpItemKindFolder      NvimTreeFolderName
]]

-- Highlights for popup menu sidebar
vim.cmd
[[
hi PmenuSbar  ctermbg=235 guibg=#202038
hi PmenuThumb ctermbg=208 guibg=#FF761A
hi PmenuSel   ctermbg=235 guibg=#202038 ctermfg=15 guifg=#DFDFE5
]]


-- Colorize borders
vim.cmd [[highlight NormalFloat guibg=NONE ctermbg=NONE]]
vim.cmd [[highlight FloatBorder guifg=#FF761A guibg=NONE ctermfg=208 ctermbg=NONE]]

vim.cmd [[ highlight Search cterm=bold ctermfg=0 ctermbg=153 gui=bold guifg=#020221 guibg=#BFDAFF ]]

-- Colorscheme for telescope
vim.cmd
[[
hi TelescopeBorder ctermfg=208 ctermbg=NONE guifg=#FF761A guibg=NONE
hi TelescopeNormal ctermbg=NONE guibg=NONE
hi TelescopePreviewNormal ctermbg=NONE guibg=NONE
hi TelescopeResultNormal ctermbg=NONE guibg=NONE
hi TelescopeTitle ctermbg=NONE guibg=NONE
hi TelescopePreviewTitle ctermbg=NONE guibg=NONE
hi link TelescopePreviewMatch Search
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
hi BufferCurrentMod guifg=#FF761A ctermfg=208 guibg=NONE ctermbg=NONE
hi BufferVisible guifg=#EFEFEF ctermfg=white guibg=#212127
hi BufferVisibleMod guifg=#FF761A ctermfg=208 guibg=#212127
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

-- For `trouble`
vim.cmd [[ hi TroubleFoldIcon guibg=NONE ctermbg=NONE ]]

-- Highlight current line number
vim.cmd
[[
  highlight CursorLineNr cterm=NONE ctermbg=NONE ctermfg=white gui=NONE guibg=NONE guifg=#EFEFEF 
  set cursorline
  set cursorlineopt=number
 ]]
