local hlgroups = require('plugin.winbar.hlgroups')
local bar = require('plugin.winbar.bar')
_G.winbar = {}

---@type winbar_t[]
local bars = {}
setmetatable(bars, {
  __index = function(k)
    bars[k] = bar.winbar_t:new()
    return bars[k]
  end,
})

---Get winbar string for current window
---@return string
function winbar.get_winbar()
  local buf = vim.api.nvim_get_current_buf()
  if not bars[buf] then
    bars[buf] = bar.winbar_t:new()
  end
  return bars[buf]()
end

---Setup winbar
local function setup()
  hlgroups.init()
  local groupid = vim.api.nvim_create_augroup('WinBar', {})
  ---Init winbar
  ---@param win number
  ---@param buf number
  local function _init(win, buf)
    if
      not vim.api.nvim_win_get_config(win).zindex
      and vim.bo[buf].buftype == ''
      and vim.api.nvim_buf_get_name(buf) ~= ''
      and not vim.wo[win].diff
    then
      vim.wo.winbar = '%{%v:lua.winbar.get_winbar()%}'
    end
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    _init(win, vim.api.nvim_win_get_buf(win))
  end
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWritePost' }, {
    group = groupid,
    callback = function(info)
      _init(0, info.buf)
    end,
    desc = 'Set winbar on buffer/window enter and write post.',
  })
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufUnload', 'BufWipeOut' }, {
    group = groupid,
    callback = function(info)
      bars[info.buf] = nil
    end,
    desc = 'Remove winbar from cache on buffer delete/unload/wipeout.',
  })
  -- Disable winbar in diff mode
  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = 'diff',
    group = groupid,
    callback = function()
      if vim.v.option_new == '1' then
        vim.w.winbar = vim.wo.winbar
        vim.wo.winbar = nil
      elseif vim.w.winbar then
        vim.wo.winbar = vim.w.winbar
      end
    end,
    desc = 'Disable winbar in diff mode.',
  })
  vim.g.loaded_winbar = true
end

return {
  setup = setup,
}
