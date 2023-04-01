vim.api.nvim_create_augroup('StatusColumn', { clear = true })
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  group = 'StatusColumn',
  callback = function(tbl)
    require('plugin.statuscolumn')
    if tbl.file and vim.loop.fs_stat(tbl.file) and vim.bo.bt == '' then
      vim.wo.statuscolumn = '%!v:lua.get_statuscol()'
      return
    end
    vim.wo.statuscolumn = ''
  end,
})
