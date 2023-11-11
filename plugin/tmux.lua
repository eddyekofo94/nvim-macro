if vim.env.TMUX and not vim.tbl_isempty(vim.api.nvim_list_uis()) then
  vim.schedule(function()
    require('plugin.tmux').setup()
  end)
end
