---Check if a file is a git (commit, rebase, etc.) file
---@param fpath string
---@return boolean
local function is_gitfile(fpath)
  return (
    fpath:find('.git/rebase-merge', 1, true)
    or fpath:find('.git/COMMIT_EDITMSG', 1, true)
  )
      and true
    or false
end

require('flatten').setup({
  window = {
    open = 'smart',
  },
  callbacks = {
    should_nest = function()
      local files = vim.fn.argv() --[=[@as string[]]=]
      for _, file in ipairs(files) do
        if file:find('^/tmp') then
          return true
        end
      end
      return false
    end,
    should_block = function()
      local files = vim.fn.argv() --[=[@as string[]]=]
      for _, file in ipairs(files) do
        if is_gitfile(file) then
          return true
        end
      end
      return false
    end,
    post_open = function(buf, win)
      vim.api.nvim_set_current_win(win)
      local bufname = vim.api.nvim_buf_get_name(buf)
      if is_gitfile(bufname) then
        vim.bo[buf].bufhidden = 'wipe'
      end
    end,
  },
  one_per = {
    kitty = false,
    wezterm = false,
  },
})
