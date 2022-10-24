return {
  'preservim/vim-markdown',
  setup = function ()
    vim.cmd([[
      let g:vim_markdown_conceal = 0
      let g:vim_markdown_math = 1
      let g:tex_conceal = ''
    ]])
  end,
}
