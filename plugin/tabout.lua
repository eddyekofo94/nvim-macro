vim.keymap.set('i', '<Tab>', function() require('plugin.tabout').remap_func('<Tab>') end, { noremap = true })
vim.keymap.set('i', '<S-Tab>', function() require('plugin.tabout').remap_func('<S-Tab>') end, { noremap = true })
