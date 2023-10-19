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
    post_open = function(bufnr, winnr, ft, _)
      vim.api.nvim_set_current_win(winnr)
      -- If the file is a git commit or git rebase, create one-shot autocmd to
      -- delete its buffer on write
      if ft == 'gitcommit' or ft == 'gitrebase' then
        vim.api.nvim_create_autocmd('BufWritePost', {
          buffer = bufnr,
          once = true,
          callback = function()
            vim.defer_fn(function()
              vim.api.nvim_buf_delete(bufnr, {})
            end, 50)
            return true
          end,
        })
      end
    end,
  },
  one_per = {
    kitty = false,
    wezterm = false,
  },
})
