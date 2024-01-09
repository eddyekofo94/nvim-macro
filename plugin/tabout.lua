vim.keymap.set({ 'i', 'c' }, '<Tab>', function()
  require('plugin.tabout').do_key('<Tab>')
end)

vim.keymap.set({ 'i', 'c' }, '<S-Tab>', function()
  require('plugin.tabout').do_key('<S-Tab>')
end)
