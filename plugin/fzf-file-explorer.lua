if vim.g.loaded_fzf_file_explorer then
  return
end

vim.g.loaded_fzf_file_explorer = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

---@type table<number, true>
local buf_created = {}

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
  -- Switch to alternate buffer or create new buffer to
  -- keep the view 'untouched'
  do
    local bufcur = vim.api.nvim_get_current_buf()
    if isdir(vim.api.nvim_buf_get_name(bufcur)) then
      vim.bo[bufcur].bufhidden = 'wipe'
      local buf0 = vim.fn.bufnr(0)
      if buf0 == -1 or buf0 == bufcur or buf_created[bufcur] then
        vim.cmd.enew()
      else
        vim.cmd.buffer('#')
      end
    end
  end
  -- Open fzf window
  vim.cmd('FZF ' .. vim.fn.fnameescape(dir))
end

local groupid = vim.api.nvim_create_augroup('FzfFileExploer', {})
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
    -- Record buffer creation to determine if we are going
    -- to wipe out the buffer when are are editing this
    -- buffer as a directory
    -- If the current buffer in `fzf_edit_dir()` is not
    -- recorded, it means that the buffer is created by
    -- `:e <dir>` and we should wipe out the buffer and
    -- switch to an alternate one;
    -- else the buffer is create by user and we should
    -- use `:enew` to create a new buffer to keep the view
    buf_created[info.buf] = true
  end,
})

vim.api.nvim_create_autocmd('BufWipeOut', {
  group = groupid,
  callback = function(info)
    -- Remove buffer creation record
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(info.buf) then
        buf_created[info.buf] = nil
      end
    end)
  end,
})
