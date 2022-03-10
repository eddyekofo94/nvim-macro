local get = require('utils.get')
local langs = require('utils.shared').langs

return {
  'neovim/nvim-lspconfig',
  opt = true,
  ft = get.ft_list(langs)
}
