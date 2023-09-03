return {
  {
    'karb94/neoscroll.nvim',
    enabled = function()
      return vim.env.COLORTERM
      -- return false
    end,
    keys = {
      '<C-y>',
      '<C-e>',
      '<C-b>',
      '<C-f>',
      '<C-u>',
      '<C-d>',
      '<S-Up>',
      '<S-Down>',
      '<PageUp>',
      '<PageDown>',
      '<S-PageUp>',
      '<S-PageDown>',
      'zb',
      'zt',
      'zz',
    },
    config = function()
      require('configs.neoscroll')
    end,
  },
}
