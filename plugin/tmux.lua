if
  not vim.env.TMUX
  or not vim.env.TMUX_PANE
  or vim.fn.executable('tmux') == 0
  or vim.tbl_isempty(vim.api.nvim_list_uis())
then
  return
end

vim.defer_fn(function()
  require('plugin.tmux').setup()
end, 100)
