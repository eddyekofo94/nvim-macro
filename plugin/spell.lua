local hl_spellbad = {}

vim.api.nvim_create_augroup('AutoSpell', { clear = true })
vim.api.nvim_create_autocmd({ 'ColorScheme', 'UIEnter' }, {
  pattern = '*',
  group = 'AutoSpell',
  callback = function()
    hl_spellbad = vim.api.nvim_get_hl(0, { name = 'SpellBad' })
    local mode = vim.fn.mode()
    if not vim.startswith(mode, 'i') and not vim.startswith(mode, 'R') then
      vim.cmd.hi('clear SpellBad')
    end
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  group = 'AutoSpell',
  callback = function()
    if vim.bo.bt == '' then
      vim.wo.spell = true
      vim.cmd.hi('clear SpellBad')
    else
      vim.wo.spell = false
    end
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  group = 'AutoSpell',
  callback = function()
    if hl_spellbad then
      vim.api.nvim_set_hl(0, 'SpellBad', hl_spellbad)
    end
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  group = 'AutoSpell',
  command = 'hi clear SpellBad',
})
