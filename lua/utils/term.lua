local M = {}

local default_shells = {
  sh = true,
  zsh = true,
  bash = true,
  dash = true,
  fish = true,
}

---Check if a session is running a shell (sh, bash, dash, zsh, fish) in
---its last process
---caveat: does not work with `sudo [opts] <shell>`
---@param pid integer? default to jobpid(&channel)
---@param shells table<string, true> default contains 'sh', 'bash', 'dash', 'zsh', 'fish'
---@return boolean? true if the last process is a shell, false if not, nil if error
function M.running_shell(pid, shells)
  pid = pid or vim.bo.channel == 0 and 0 or vim.fn.jobpid(vim.bo.channel)
  if pid == 0 then -- Invalid pid
    return
  end
  shells = vim.tbl_deep_extend('force', default_shells, shells or {})
  local last_cmd =
    vim.trim(vim.fn.system('ps h -o comm -g ' .. pid .. ' | tail -n1'))
  if vim.v.shell_error > 0 then
    return nil
  end
  return shells[last_cmd] ~= nil
end

return M
