return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown' },
    config = function()
      require('configs.vimtex')
    end,
  },

  {
    'preservim/vim-markdown',
    ft = 'markdown',
    init = function ()
      vim.g.tex_conceal = ''  -- let vimtex manage conceal
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_new_list_item_indent = 0
    end,
  },

  {
    'ekickx/clipboard-image.nvim',
    ft = { 'tex', 'markdown' },
    config = function()
      require('configs.clipboard-image')
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    ft = 'markdown',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_theme = 'light'
    end,
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    keys = '<Leader>tm',
  },
}
