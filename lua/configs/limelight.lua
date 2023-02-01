local function set_limelight_conceal_color()
  if vim.o.background == 'dark' then
    vim.g.limelight_conceal_guifg = '#415160'
  else
    vim.g.limelight_conceal_guifg = '#a5b5b8'
  end
end

local twilight_exclude = {
  'markdown',
  'tex',
}

local function limelight_check()
  if vim.g.twilight_active
      and vim.tbl_contains({ 'markdown', 'tex' }, vim.bo.ft) then
    vim.cmd('silent! Limelight')
  else
    vim.cmd('silent! Limelight!')
  end
end

M.set_limelight_conceal_color()

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_limelight_conceal_color,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = require('modules.ui.utils').limelight_check,
})

return {
  limelight_check = limelight_check,
}
