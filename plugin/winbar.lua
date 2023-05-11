vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWritePost' }, {
  group = vim.api.nvim_create_augroup('WinBarSetup', {}),
  callback = function(info)
    if not vim.g.loaded_winbar and info.file ~= '' then
      require('plugin.winbar').setup()
    end
  end
})
