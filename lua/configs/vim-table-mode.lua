vim.api.nvim_create_augroup('TableModeSetTableCorner', { clear = true })
vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'markdown',
  group = 'TableModeSetTableCorner',
  command = 'let b:table_mode_corner = "|"',
})

vim.api.nvim_create_augroup('TableModeAutoEnable', { clear = true })
vim.api.nvim_create_autocmd({
  'CursorMoved',
  'CursorMovedI',
  'TextChanged',
  'TextChangedI',
  'BufWinEnter',
}, {
  pattern = { '*.txt', '*.md' },
  group = 'TableModeAutoEnable',
  callback = function(tbl)
    if vim.bo[tbl.buf].ft == 'help' then
      return
    end
    local line = vim.api.nvim_get_current_line()
    if line:match('^%s*|') then
      if not vim.g.tablemode_enabled then
        vim.cmd('TableModeEnable')
        vim.g.tablemode_enabled = true
      end
    elseif vim.g.tablemode_enabled then
      vim.cmd('TableModeDisable')
      vim.g.tablemode_enabled = false
    end
  end,
})
