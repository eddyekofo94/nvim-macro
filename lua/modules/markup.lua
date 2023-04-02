return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown' },
    config = function()
      require('configs.vimtex')
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
    'mickael-menu/zk-nvim',
    ft = 'markdown',
    cmd = {
      'ZkNew',
      'ZkTags',
      'ZkLinks',
      'ZkNotes',
      'ZkMatch',
      'ZkInsertLink',
      'ZkInsertLinkAtSelection',
      'ZkNewFromTitleSelection',
      'ZkNewFromContentSelection',
    },
    config = function()
      require('configs.zk-nvim')
    end,
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    event = { 'BufReadPost', 'BufNew' },
    config = function()
      require('configs.vim-table-mode')
    end
  },
}
