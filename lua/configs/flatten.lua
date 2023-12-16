---Check if a file is a git (commit, rebase, etc.) file
---@param fpath string
---@return boolean
local function should_block_file(fpath)
  fpath = vim.fs.normalize(fpath)
  return (
    fpath:find('.git/rebase-merge', 1, true)
    or fpath:find('.git/COMMIT_EDITMSG', 1, true)
    or fpath:find('^/tmp')
  )
      and true
    or false
end

require('flatten').setup({
  window = {
    open = 'current',
  },
  callbacks = {
    should_block = function()
      local files = vim.fn.argv() --[=[@as string[]]=]
      for _, file in ipairs(files) do
        if should_block_file(file) then
          return true
        end
      end
      return false
    end,
    post_open = function(buf, win)
      vim.api.nvim_set_current_win(win)
      local bufname = vim.api.nvim_buf_get_name(buf)
      if should_block_file(bufname) then
        vim.bo[buf].bufhidden = 'wipe'
      end
    end,
  },
  one_per = {
    kitty = false,
    wezterm = false,
  },
})
