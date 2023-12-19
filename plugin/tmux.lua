if vim.env.TMUX and vim.g.has_ui then
  vim.schedule(function()
    require('plugin.tmux').setup()
  end)
end
