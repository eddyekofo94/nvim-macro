local M = {}
local configs = require('modules.markup.configs')

M['vimtex'] = {
  'lervag/vimtex',
  ft = { 'tex', 'markdown' },
  setup = function()
    vim.g.vimtex_mappings_enabled = 0
    vim.g.vimtex_motion_enabled = 0
    vim.g.vimtex_syntax_conceal = { math_bounds = 0 }
  end,
}

M['vim-markdown'] = {
  'preservim/vim-markdown',
  ft = 'markdown',
  setup = function ()
    vim.g.tex_conceal = ''  -- let vimtex manage conceal
    vim.g.vim_markdown_math = 1
    vim.g.vim_markdown_conceal_code_blocks = 0
    vim.g.vim_markdown_auto_insert_bullets = 0
    vim.g.vim_markdown_no_default_key_mappings = 1
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
