return {
  'lervag/vimtex',
  opt = false,
  setup = function ()
    vim.cmd([[
      filetype plugin indent on
      syntax enable
      let g:vimtex_syntax_conceal_disable = 1
    ]])
  end
}
