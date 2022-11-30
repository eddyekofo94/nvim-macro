-- true:  use module
-- false: disable module
-- nil:   remove module
require('utils.packer').use_modules({
  base = true,
  completion = true,
  git = true,
  lsp = true,
  markup = true,
  misc = true,
  tools = true,
  treesitter = true,
  ui = true,
})
