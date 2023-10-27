require('flatten').setup({
  window = {
    open = 'alternate',
  },
  callbacks = {
    should_block = function(argv)
      for _, arg in ipairs(argv) do
        if arg:find('.git/rebase-merge', 1, true) then
          return true
        end
      end
      return false
    end,
    post_open = function(buf, win, ft, _)
      vim.api.nvim_set_current_win(win)
      if
        (ft == 'gitcommit' or ft == 'gitrebase')
        and vim.api.nvim_buf_get_name(buf):find('.git/rebase-merge')
      then
        vim.bo[buf].bufhidden = 'wipe'
      end
    end,
  },
  one_per = {
    kitty = false,
    wezterm = false,
  },
})
