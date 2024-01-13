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
    init = function(plugin)
      -- Ensure parsers and queries provided by treesitter precedes
      -- nvim bundled ones in rtp to make sure that the version of
      -- queries and parsers are in sync, see
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
      vim.api.nvim_create_autocmd({ 'FileType', 'BufReadPre' }, {
        once = true,
        callback = function()
          require('lazy.core.loader').add_to_rtp(plugin)
          require('nvim-treesitter.query_predicates')
          return true
        end,
      })
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
}
