vim.cmd [[ colorscheme falcon ]]
vim.g.falcon_background = 0

-- Fix gitignored file icon display in nvim-tree
vim.cmd
[[ 
hi NvimTreeGitIgnored guifg=#787882 ctermfg=248
\guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
]]
