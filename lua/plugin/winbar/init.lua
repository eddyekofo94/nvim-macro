_G.winbar = {}
local hlgroups = require('plugin.winbar.hlgroups')
local bar = require('plugin.winbar.bar')
local sources = require('plugin.winbar.sources')

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

---Create a winbar source instance with fallback
---@param source_list winbar_source_t[]
---@return winbar_source_t
local function source_fallback(source_list)
  return {
    get_symbols = function(buf, cursor)
      local symbols = {}
      for _, source in ipairs(source_list) do
        symbols = source.get_symbols(buf, cursor)
        if not vim.tbl_isempty(symbols) then
          break
        end
      end
      return symbols
    end,
  }
end

---@type table<integer, table<integer, winbar_t>>
_G.winbar.bars = setmetatable({}, {
  __index = function(self, buf)
    self[buf] = setmetatable({}, {
      __index = function(this, win)
        this[win] = bar.winbar_t:new({
          sources = {
            sources.path,
            source_fallback({
              sources.lsp,
              sources.treesitter,
            }),
          },
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
local function setup()
  hlgroups.init()
  local groupid = vim.api.nvim_create_augroup('WinBar', {})
  ---Init winbar
  ---@param win integer
  ---@param buf integer
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
      if not vim.tbl_contains(vim.tbl_keys(_G.winbar.bars), info.buf) then
        return
      end
      for win, _ in pairs(_G.winbar.bars[info.buf]) do
        _G.winbar.bars[info.buf][win]:del()
        _G.winbar.bars[info.buf][win] = nil
        _G.winbar.on_click_callbacks['buf' .. info.buf][win] = nil
      end
      _G.winbar.bars[info.buf] = nil
    end,
    desc = 'Remove winbar from cache on buffer delete/unload/wipeout.',
  })
  vim.api.nvim_create_autocmd({
    'CursorMoved',
    'CursorMovedI',
    'TextChanged',
    'TextChangedI',
    'WinScrolled',
    'WinResized',
    'VimResized',
  }, {
    group = groupid,
    callback = function(info)
      local win = info.event == 'WinScrolled' and tonumber(info.match)
        or vim.api.nvim_get_current_win()
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.tbl_contains(vim.tbl_keys(_G.winbar.bars), buf) then
        _G.winbar.bars[buf][win]:update()
      end
    end,
    desc = 'Update winbar on cursor move, window/buffer enter, text change.',
  })
  vim.api.nvim_create_autocmd({ 'WinClosed' }, {
    group = groupid,
    callback = function(info)
      if not vim.tbl_contains(vim.tbl_keys(_G.winbar.bars), info.buf) then
        return
      end
      local win = tonumber(info.match)
      _G.winbar.bars[info.buf][win]:del()
      ---@diagnostic disable-next-line: need-check-nil
      _G.winbar.bars[info.buf][win] = nil
      _G.winbar.on_click_callbacks['buf' .. info.buf]['win' .. win] = nil
    end,
    desc = 'Remove winbar from cache on window closed.',
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
