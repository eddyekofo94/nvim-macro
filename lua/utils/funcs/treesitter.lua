local M = {}

---Returns whether the current buffer has treesitter enabled
---@param buf integer? default: current buffer
---@return boolean
function M.ts_active(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.treesitter.highlighter.active[buf] ~= nil
end

---Returns whether current cursor is in a comment
---@param type string type of node
---@param pos integer[]? 1,0-indexed position, default: current cursor position
---@param buf integer? default: current buffer
---@return boolean
function M.in_tsnode(type, pos, buf)
  pos = pos or vim.api.nvim_win_get_cursor(0)
  buf = buf or vim.api.nvim_get_current_buf()
  if not M.ts_active(buf) then
    return false
  end
  local node = vim.treesitter.get_node({
    bufnr = buf,
    pos = { pos[1] - 1, pos[2] - 1 },
  })
  if not node then
    return false
  end
  return node:type():match(type) ~= nil
end

return M
