vim.keymap.set('i', '<Tab>', function() require('plugin.tabout').do_key('<Tab>') end, { noremap = true })
vim.keymap.set('i', '<S-Tab>', function() require('plugin.tabout').do_key('<S-Tab>') end, { noremap = true })
