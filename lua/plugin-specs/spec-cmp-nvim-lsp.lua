local get = require('utils.get')

return {
  'hrsh7th/cmp-nvim-lsp',
  ft = get.ft_list(require('utils.shared').langs)
}
