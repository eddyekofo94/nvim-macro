vim.opt.listchars = {
  tab        = '→ ',
  extends    = '…',
  precedes   = '…',
  nbsp       = '⌴',
  trail      = '·',
  multispace = '·'
}

require('indent_blankline').setup({
  show_current_context = false,
  show_trailing_blankline_indent = false,
  indent_blankline_use_treesitter = false,
})
