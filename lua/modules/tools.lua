return {
  {
    'ibhagwan/fzf-lua',
    cmd = {
      'FzfLua',
      'F',
      'Ls',
      'Args',
      'Tabs',
      'Tags',
      'Files',
      'Marks',
      'Jumps',
      'Autocmd',
      'Buffers',
      'Changes',
      'Oldfiles',
      'Registers',
      'Highlight',
    },
    keys = {
      '<Leader>.',
      '<Leader>,',
      '<Leader>/',
      '<Leader>?',
      '<Leader>"',
      '<Leader>o',
      "<Leader>'",
      '<Leader>l',
      '<Leader>L',
      '<Leader>s',
      '<Leader>S',
      '<Leader>F',
      '<Leader>f',
      { '<Leader>*', mode = { 'n', 'x' } },
      { '<Leader>#', mode = { 'n', 'x' } },
    },
    init = vim.schedule_wrap(function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('fzf-lua.providers.ui_select').ui_select(...)
      end
      vim.api.nvim_create_autocmd('CmdlineEnter', {
        group = vim.api.nvim_create_augroup('FzfLuaCreateCmdAbbr', {}),
        once = true,
        callback = function(info)
          local keymap = require('utils.keymap')
          keymap.command_abbrev('ls', 'Ls')
          keymap.command_abbrev('tabs', 'Tabs')
          keymap.command_abbrev('tags', 'Tags')
          keymap.command_abbrev('files', 'Files')
          keymap.command_abbrev('marks', 'Marks')
          keymap.command_abbrev('buffers', 'Buffers')
          keymap.command_abbrev('changes', 'Changes')
          keymap.command_abbrev({ 'ar', 'args' }, 'Args')
          keymap.command_abbrev({ 'ju', 'jumps' }, 'Jumps')
          keymap.command_abbrev({ 'au', 'autocmd' }, 'Autocmd')
          keymap.command_abbrev({ 'o', 'oldfiles' }, 'Oldfiles')
          keymap.command_abbrev({ 'hi', 'highlight' }, 'Highlight')
          keymap.command_abbrev({ 'reg', 'registers' }, 'Registers')
          vim.api.nvim_del_augroup_by_id(info.group)
          return true
        end,
      })
    end),
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
    enabled = vim.g.modern_ui,
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
            require('oil')
            vim.cmd.edit()
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
