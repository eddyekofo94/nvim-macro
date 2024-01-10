return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = {
      'TSInstall',
      'TSInstallSync',
      'TSInstallInfo',
      'TSUninstall',
      'TSUpdate',
      'TSUpdateSync',
      'TSBufEnable',
      'TSBufToggle',
      'TSEnable',
      'TSToggle',
      'TSModuleInfo',
      'TSEditQuery',
      'TSEditQueryUserAfter',
    },
    event = { 'FileType', 'BufReadPre' },
    init = function()
      -- Disable nvim bundled treesitter parsers to avoid errors in markdown
      -- files, they are not compatible with nvim-treesitter's queries, see
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
      ---@diagnostic disable-next-line: undefined-field
      if not vim.g.vscode then
        vim.opt.rtp:remove('/usr/lib/nvim')
      end
    end,
    config = function()
      vim.schedule(function()
        require('configs.nvim-treesitter')
      end)
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'RRethy/nvim-treesitter-endwise',
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    keys = { '<M-C-K>', '<M-NL>', 'g<M-NL>' },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('configs.treesj')
    end,
  },

  {
    'Eandrju/cellular-automaton.nvim',
    event = 'FileType',
    cmd = 'CellularAutomaton',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },

  {
    'RRethy/nvim-treesitter-endwise',
    event = 'FileType',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
}
