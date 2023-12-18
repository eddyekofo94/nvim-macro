return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown', 'mkd' },
    config = function()
      require('configs.vimtex')
    end,
  },

  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install && cd - && git restore .',
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
    ft = 'markdown',
    config = function()
      require('configs.vim-table-mode')
    end,
  },

  {
    '3rd/image.nvim',
    event = {
      'FileType markdown,norg',
      'BufRead *.png,*.jpg,*.gif,*.webp,*.ipynb',
    },
    build = {
      'magick --version',
      'luarocks --lua-version 5.1 --local install magick',
    },
    config = function()
      require('configs.image')
    end,
  },

  {
    'jmbuhr/otter.nvim',
    ft = { 'markdown' },
    dependencies = {
      'hrsh7th/nvim-cmp',
      'neovim/nvim-lspconfig',
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
    dependencies = {
      '3rd/image.nvim',
      'jmbuhr/otter.nvim',
    },
    config = function()
      require('configs.molten')
    end,
  },

  {
    'goerz/jupytext.vim',
    build = 'jupytext --version',
    lazy = true,
    init = function()
      vim.g.jupytext_command = 'jupytext --opt notebook_metadata_filter=-all'
      vim.api.nvim_create_autocmd('BufReadCmd', {
        desc = 'Lazy load jupytext.vim.',
        once = true,
        pattern = '*.ipynb',
        group = vim.api.nvim_create_augroup('JupyTextLoad', {}),
        callback = function(info)
          vim.opt.rtp:prepend(
            vim.fs.joinpath(vim.g.package_path, 'jupytext.vim')
          )
          vim.schedule(function()
            vim.cmd.runtime({ 'plugin/jupytext.vim', bang = true })
            vim.cmd.edit(info.match)
          end)
          return true
        end,
      })
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
