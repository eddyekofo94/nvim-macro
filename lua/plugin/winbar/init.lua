_G.winbar = {}
local hlgroups = require('plugin.winbar.hlgroups')
local bar = require('plugin.winbar.bar')
local configs = require('plugin.winbar.configs')
local utils = require('plugin.winbar.utils')

---Store the on_click callbacks for each winbar symbol
---Make it assessable from global only because nvim's viml-lua interface
---(v:lua) only support calling global lua functions
---@type table<string, table<string, function>>
---@see winbar_t:update
_G.winbar.on_click_callbacks = setmetatable({}, {
  __index = function(self, buf)
    self[buf] = setmetatable({}, {
      __index = function(this, win)
        this[win] = {}
        return this[win]
      end,
    })
    return self[buf]
  end,
})

---@type table<integer, table<integer, winbar_t>>
_G.winbar.bars = setmetatable({}, {
  __index = function(self, buf)
    self[buf] = setmetatable({}, {
      __index = function(this, win)
        this[win] = bar.winbar_t:new({
          sources = configs.eval(configs.opts.bar.sources, buf, win),
        })
        return this[win]
      end,
    })
    return self[buf]
  end,
})

---Get winbar string for current window
---@return string
function _G.winbar.get_winbar()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  return tostring(_G.winbar.bars[buf][win])
end

---Setup winbar
---@param opts winbar_configs_t?
local function setup(opts)
  print('setup plugin winbar')
  configs.set(opts)
  hlgroups.init()
  local groupid = vim.api.nvim_create_augroup('WinBar', {})
  ---Enable/disable winbar
  ---@param win integer
  ---@param buf integer
  local function _switch(buf, win)
    if configs.eval(configs.opts.general.enable, buf, win) then
      vim.wo.winbar = '%{%v:lua.winbar.get_winbar()%}'
    end
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    _switch(vim.api.nvim_win_get_buf(win), win)
  end
  vim.api.nvim_create_autocmd({ 'OptionSet', 'BufWinEnter', 'BufWritePost' }, {
    group = groupid,
    callback = function(info)
      _switch(info.buf, 0)
    end,
    desc = 'Enable/disable winbar',
  })
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufUnload', 'BufWipeOut' }, {
    group = groupid,
    callback = function(info)
      utils.bar.exec({ buf = info.buf }, 'del')
      _G.winbar.bars[info.buf] = nil
    end,
    desc = 'Remove winbar from cache on buffer delete/unload/wipeout.',
  })
  if not vim.tbl_isempty(configs.opts.general.update_events.win) then
    vim.api.nvim_create_autocmd(configs.opts.general.update_events.win, {
      group = groupid,
      callback = function(info)
        if info.event == 'WinResized' then
          for _, win in ipairs(vim.v.event.windows) do
            utils.bar.exec({ win = win }, 'update')
          end
        else
          utils.bar.exec({
            win = info.event == 'WinScrolled' and tonumber(info.match)
              or vim.api.nvim_get_current_win(),
          }, 'update')
        end
      end,
      desc = 'Update a single winbar.',
    })
  end
  if not vim.tbl_isempty(configs.opts.general.update_events.buf) then
    vim.api.nvim_create_autocmd(configs.opts.general.update_events.buf, {
      group = groupid,
      callback = function(info)
        utils.bar.exec({ buf = info.buf }, 'update')
      end,
      desc = 'Update all winbars associated with buf.',
    })
  end
  if not vim.tbl_isempty(configs.opts.general.update_events.global) then
    vim.api.nvim_create_autocmd(configs.opts.general.update_events.global, {
      group = groupid,
      callback = function(info)
        if vim.tbl_isempty(utils.bar.get({ buf = info.buf })) then
          return
        end
        utils.bar.exec(nil, 'update')
      end,
      desc = 'Update all winbars.',
    })
  end
  vim.api.nvim_create_autocmd({ 'WinClosed' }, {
    group = groupid,
    callback = function(info)
      utils.bar.exec({ win = tonumber(info.match) }, 'del')
    end,
    desc = 'Remove winbar from cache on window closed.',
  })
  if configs.opts.bar.hover then
    vim.on_key(function(key)
      if key == vim.keycode('<MouseMove>') then
        utils.bar.update_hover_hl(vim.fn.getmousepos())
      end
    end)
  end
  vim.g.loaded_winbar = true
end

return {
  setup = setup,
}
