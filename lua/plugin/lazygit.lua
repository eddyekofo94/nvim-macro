local utils = require('utils')
local fterm_t = utils.classes.fterm_t ---@type fterm_t

---@alias jobid integer
---@type table<string, fterm_t>
local lazygits = {}

---@param key string key to toggle the lazygit terminal
local function toggle(key)
  ---@diagnostic disable-next-line: undefined-field
  local root = utils.fs.proj_dir(vim.uv.cwd(), { '.git/' })
  if root then
    if lazygits[root] then
      lazygits[root]:toggle()
    else
      lazygits[root] = fterm_t:new('lazygit', {
        winopts = { border = 'solid' },
        jobopts = { cwd = root },
        termopts = {
          init = function(term)
            vim.keymap.set('t', key, function()
              term:close()
            end, { buffer = term.buf })
          end,
          on_open = function()
            vim.cmd.startinsert()
          end,
        },
      })
    end
  end
end

return {
  toggle = toggle,
}
