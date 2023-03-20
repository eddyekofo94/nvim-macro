local function init_spell()
  vim.wo.spell = true
  vim.bo.spelllang = 'en,cjk'
  vim.opt.spellsuggest = 'best,9'
  vim.bo.spellcapcheck = ''
  vim.bo.spelloptions = 'camel'
  vim.cmd('hi clear SpellBad')
end

vim.api.nvim_create_augroup('AutoSpell', { clear = true })
vim.api.nvim_create_autocmd({
  'BufReadPre',
  'BufWritePost'
}, {
  pattern = '*',
  group = 'AutoSpell',
  callback = init_spell,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  group = 'AutoSpell',
  command = 'hi clear SpellBad',
})

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  group = 'AutoSpell',
  command = 'hi SpellBad gui=underdotted',
})

vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  pattern = '*',
  group = 'AutoSpell',
  command = 'if mode() == "n" | hi clear SpellBad | endif',
})
