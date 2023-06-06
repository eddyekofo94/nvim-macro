---@param win integer
---@generic T
---@param fn fun(...): T?
---@return T?
local function win_execute(win, fn, ...)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end
  local cur_win = vim.api.nvim_get_current_win()
  vim.cmd('noautocmd silent keepjumps call win_gotoid(' .. win .. ')')
  local ret = { fn(...) }
  vim.cmd('noautocmd silent keepjumps call win_gotoid(' .. cur_win .. ')')
  return unpack(ret)
end

return {
  win_execute = win_execute,
}
