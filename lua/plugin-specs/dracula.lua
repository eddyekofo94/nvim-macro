return {
  'Mofiqul/dracula.nvim',
  cond = function ()
    return vim.g.colorscheme == 'dracula'
  end,
  config = require('utils.get').config('dracula')
}
