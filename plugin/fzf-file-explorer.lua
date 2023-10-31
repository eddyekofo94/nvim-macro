local groupid = vim.api.nvim_create_augroup('FzfFileExploer', {})

---Check if a path is a directory
---@param path string
---@return boolean?
local function isdir(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'directory'
end

---@param dir string
---@return nil
local function fzf_edit_dir(dir)
  if not isdir(dir) or vim.fn.exists(':FZF') ~= 2 then
    return
  end
  do -- Switch to alternate buffer if current buffer is a directory
    local bufcur = vim.api.nvim_get_current_buf()
    if isdir(vim.api.nvim_buf_get_name(bufcur)) then
      vim.bo[bufcur].bufhidden = 'wipe'
      local buf0 = vim.fn.bufnr(0)
      if buf0 > 0 and buf0 ~= bufcur then
        vim.cmd.buffer('#')
      else
        vim.cmd.enew()
      end
    end
  end
  -- Open fzf window
  vim.cmd('FZF ' .. vim.fn.fnameescape(dir))
end

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  group = groupid,
  callback = function()
    vim.g.ui_entered = true
    if vim.g.fzf_defer_edit_dir then
      fzf_edit_dir(vim.g.fzf_defer_edit_dir)
      vim.g.fzf_defer_edit_dir = nil
    end
    return true
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = groupid,
  callback = function(info)
    -- Defer opening fzf window until UIEnter autocmd
    -- for colorshemes to be loaded
    if not vim.g.ui_entered then
      vim.g.fzf_defer_edit_dir = info.match
      return
    end
    fzf_edit_dir(info.match)
  end,
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
