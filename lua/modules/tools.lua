return {
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua', 'F', 'FZ', 'FZF' },
    keys = {
      '<Leader>.',
      '<Leader>,',
      '<Leader>/',
      '<Leader>s',
      '<Leader>S',
      '<Leader>F',
      '<Leader>f',
      '<Leader>f"',
      '<Leader>f*',
      '<Leader>f/',
      '<Leader>f:',
      '<Leader>fD',
      '<Leader>fE',
      '<Leader>fH',
      '<Leader>fO',
      '<Leader>fS',
      '<Leader>fa',
      '<Leader>fb',
      '<Leader>fc',
      '<Leader>fd',
      '<Leader>fe',
      '<Leader>ff',
      '<Leader>fg',
      '<Leader>fG',
      '<Leader>fh',
      '<Leader>fk',
      '<Leader>fl',
      '<Leader>fL',
      '<Leader>fm',
      '<Leader>fo',
      '<Leader>fq/',
      '<Leader>fq:',
      '<Leader>fq?',
      '<Leader>fr',
      '<Leader>fs',
    },
    config = function()
      require('configs.fzf-lua')
    end,
  },

  {
    'willothy/flatten.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.flatten')
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('configs.gitsigns')
    end,
  },

  {
    'tpope/vim-fugitive',
    cmd = {
      'G',
      'Gcd',
      'Gclog',
      'Gdiffsplit',
      'Gdrop',
      'Gedit',
      'Ggrep',
      'Git',
      'Glcd',
      'Glgrep',
      'Gllog',
      'Gpedit',
      'Gread',
      'Gsplit',
      'Gtabedit',
      'Gvdiffsplit',
      'Gvsplit',
      'Gwq',
      'Gwrite',
    },
    event = { 'BufWritePost', 'BufReadPre' },
    config = function()
      require('configs.vim-fugitive')
    end,
  },

  {
    'akinsho/git-conflict.nvim',
    event = 'BufReadPre',
    config = function()
      require('configs.git-conflict')
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufNew', 'BufRead' },
    config = function()
      require('configs.nvim-colorizer')
    end,
  },

  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    init = function() -- Load oil on startup only when editing a directory
      vim.g.loaded_fzf_file_explorer = 1
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.api.nvim_create_autocmd('BufEnter', {
        nested = true,
        group = vim.api.nvim_create_augroup('OilInit', {}),
        callback = function(info)
          local path = info.file
          if path == '' then
            return
          end
          -- Workaround for path with trailing `..`
          if path:match('%.%.$') then
            path = vim.fs.dirname(vim.fs.dirname(path) or '')
            if not path or path == '' then
              return
            end
          end
          local stat = vim.uv.fs_stat(path)
          if stat and stat.type == 'directory' then
            vim.api.nvim_exec_autocmds('UIEnter', {})
            pcall(require('oil').open, path)
            return true
          end
        end,
      })
    end,
    config = function()
      require('configs.oil')
    end,
  },
}
