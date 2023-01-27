local M = {}
local configs = require('modules.markup.configs')

M['vimtex'] = {
  'lervag/vimtex',
  ft = { 'tex', 'markdown' },
  config = configs['vimtex'],
}

M['vim-markdown'] = {
  'preservim/vim-markdown',
  ft = 'markdown',
  setup = function ()
    vim.g.tex_conceal = ''  -- let vimtex manage conceal
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_conceal_code_blocks = 0
    vim.g.vim_markdown_auto_insert_bullets = 0
    vim.g.vim_markdown_new_list_item_indent = 0
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
