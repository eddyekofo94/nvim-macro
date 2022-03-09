require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  filetype = require('utils.get').ft_list(require('utils.shared').langs),
  use_treesitter = true,
  show_trailing_blankline_indent = false,
  max_indent_increase = 1
}
