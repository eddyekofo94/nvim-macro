return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown' },
    config = function()
      require('configs.vimtex')
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    enabled = vim.g.modern_ui or false,
    ft = 'markdown',
    build = 'cd app && npm install && cd - && git restore .',
    config = function()
      require('configs.markdown-preview')
    end,
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    ft = 'markdown',
    config = function()
      require('configs.vim-table-mode')
    end,
  },

  {
    'jmbuhr/otter.nvim',
    ft = { 'markdown' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('configs.otter')
    end,
  },

  {
    'benlubas/molten-nvim',
    ft = 'python',
    event = 'BufEnter *.ipynb',
    build = ':UpdateRemotePlugins',
    config = function()
      require('configs.molten')
    end,
  },

  {
    'lukas-reineke/headlines.nvim',
    ft = { 'markdown', 'norg', 'org', 'qml' },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('configs.headlines')
    end,
  },
}
