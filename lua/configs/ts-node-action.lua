local action = require('ts-node-action')
vim.keymap.set('n', '<leader><leader>',
  action.node_action, { noremap = true, silent = true })
action.setup({})
