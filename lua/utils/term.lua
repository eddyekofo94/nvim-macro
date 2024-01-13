local M = {}

---Get list of names of the processes running in the terminal
---@param buf integer? terminal buffer handler, default to 0 (current)
---@return string[]: process names
function M.proc_names(buf)
  buf = buf or 0
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].bt ~= 'terminal' then
    return {}
  end
  local channel = vim.bo[buf].channel
  local chan_valid, pid = pcall(vim.fn.jobpid, channel)
  if not chan_valid then
    return {}
  end
  return vim.split(vim.fn.system('ps h -o comm -g ' .. pid), '\n', {
    trimempty = true,
  })
end

return M
