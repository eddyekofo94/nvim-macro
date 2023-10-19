local utils = require('utils')
local fterm_t = utils.classes.fterm_t ---@type fterm_t

---@alias jobid integer
---@type table<string, fterm_t>
local lazygits = {}

---@param keys string[] keys to toggle the lazygit terminal
local function toggle(keys)
  ---@diagnostic disable-next-line: undefined-field
  local cwd = vim.uv.cwd()
  local root = utils.fs.proj_dir(cwd, { '.git/' }) or cwd
  if root then
    if lazygits[root] then
      lazygits[root]:toggle()
    else
      lazygits[root] = fterm_t:new('lazygit', {
        winopts = { border = 'solid' },
        jobopts = { cwd = root },
        termopts = { toggle_keys = keys },
      })
    end
  else
    vim.notify('[lazygit] vim.uv.cwd() failed!', vim.log.levels.WARN)
  end
end

return {
  toggle = toggle,
}
