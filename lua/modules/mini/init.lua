return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.bufremove').setup()

      require('mini.trailspace').setup({})

      require('mini.fuzzy').setup()

      -- map("n", "<leader>sn", MiniFuzzy.filtersort(word, candidate_array), opts)
      --  INFO: 2024-05-15 - I already have something set up, maybe remove it and change to
      -- this in the future?

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  {
    'echasnovski/mini.comment',
    event = 'VeryLazy',
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring()
            or vim.bo.commentstring
        end,
      },
    },
  },

  -- Split and join arguments
  {
    'echasnovski/mini.splitjoin',
    keys = {
      {
        'sj',
        '<cmd>lua MiniSplitjoin.join()<CR>',
        mode = { 'n', 'x' },
        desc = 'Join arguments',
      },
      {
        'sk',
        '<cmd>lua MiniSplitjoin.split()<CR>',
        mode = { 'n', 'x' },
        desc = 'Split arguments',
      },
    },
    opts = {
      mappings = { toggle = '' },
    },
  },
}
