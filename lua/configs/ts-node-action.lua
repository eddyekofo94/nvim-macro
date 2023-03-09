local action = require('ts-node-action')
vim.keymap.set('n', '<leader><leader>',
  function() pcall(action.node_action) end, { noremap = true, silent = true })
action.setup({})
