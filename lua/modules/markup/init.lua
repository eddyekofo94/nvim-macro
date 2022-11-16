local M = {}
local configs = require('modules.markup.configs')

M['vimtex'] = {
  'lervag/vimtex',
  ft = { 'tex', 'markdown' },
}

M['vim-markdown'] = {
  'preservim/vim-markdown',
  ft = 'markdown',
  setup = function ()
    vim.cmd('let g:vim_markdown_math = 1')
  end,
}

M['clipboard-image.nvim'] = {
  'ekickx/clipboard-image.nvim',
  ft = { 'tex', 'markdown' },
  config = configs['clipboard-image.nvim'],
}

M['markdown-preview'] = {
  'iamcco/markdown-preview.nvim',
  run = 'cd app && npm install',
  ft = 'markdown',
  setup = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_theme = 'light'
  end,
}

return M
