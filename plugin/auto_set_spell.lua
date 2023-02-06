local function init_spell()
  vim.wo.spell = true
  vim.bo.spelllang = 'en,cjk'
  vim.opt.spellsuggest = 'best,9'
  vim.bo.spellcapcheck = ''
  vim.bo.spelloptions = 'camel'
  vim.cmd('hi clear SpellBad')
end

vim.api.nvim_create_autocmd({
  'BufReadPre',
  'BufWritePost'
}, {
  pattern = '*',
  callback = init_spell,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  command = 'hi clear SpellBad',
})

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  command = 'hi SpellBad gui=underdotted',
})

vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  pattern = '*',
  command = 'if mode() == "n" | hi clear SpellBad | endif',
})
