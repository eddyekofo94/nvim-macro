local static = require('utils.static')

---Add highlight to a string
---@param str string
---@param hlgroup string?
---@return string
local function hl(str, hlgroup)
  if not hlgroup or hlgroup:match('^%s*$') then
    return str
  end
  return string.format('%%#%s#%s%%*', hlgroup, str or '')
end

---Make a winbar string clickable
---@param str string
---@param callback string
---@return string
local function make_clickable(str, callback)
  return string.format('%%@%s@%s%%X', callback, str)
end

---@class winbar_symbol_t
---@field name string
---@field icon string
---@field name_hl string?
---@field icon_hl string?
---@field bar winbar_t? the winbar the symbol belongs to, if the symbol is shown inside a winbar
---@field menu winbar_menu_t? menu associated with the winbar symbol, if the symbol is shown inside a winbar
---@field entry winbar_menu_entry_t? the winbar entry the symbol belongs to, if the symbol is shown inside a menu
---@field data table? any data associated with the symbol
---@field bar_idx integer? index of the symbol in the winbar
---@field entry_idx integer? index of the symbol in the menu entry
---@field on_click fun(this: winbar_symbol_t?, min_width: integer?, n_clicks: integer?, button: string?, modifiers: string?)|false? force disable on_click when false
local winbar_symbol_t = {}
winbar_symbol_t.__index = winbar_symbol_t

---Create a winbar symbol instance
---@param opts winbar_symbol_t?
---@return winbar_symbol_t
function winbar_symbol_t:new(opts)
  return setmetatable(
    vim.tbl_deep_extend('force', {
      name = '',
      icon = '',
    }, opts or {}),
    winbar_symbol_t
  )
end

---Delete a winbar symbol instance
---@return nil
function winbar_symbol_t:del()
  if self.menu then
    self.menu:del()
    if self.menu.win then
      _G.winbar.menus[self.menu.win] = nil
    end
  end
end

---Concatenate inside a winbar symbol to get the final string
---@param plain boolean?
---@return string
function winbar_symbol_t:cat(plain)
  if plain then
    return self.icon .. self.name
  end
  local icon_highlighted = hl(self.icon, self.icon_hl)
  local name_highlighted = hl(self.name, self.name_hl)
  if self.on_click and self.bar_idx then
    return make_clickable(
      icon_highlighted .. name_highlighted,
      string.format(
        'v:lua.winbar.on_click_callbacks.buf%s.win%s.fn%s',
        self.bar.buf,
        self.bar.win,
        self.bar_idx
      )
    )
  end
  return icon_highlighted .. name_highlighted
end

---Get the display length of the winbar symbol
---@return number
function winbar_symbol_t:displaywidth()
  return vim.fn.strdisplaywidth(self:cat(true))
end

---Get the byte length of the winbar symbol
---@return number
function winbar_symbol_t:bytewidth()
  return #self:cat(true)
end

---@class winbar_opts_t
---@field buf integer?
---@field win integer?
---@field sources winbar_source_t[]?
---@field separator winbar_symbol_t?
---@field extends winbar_symbol_t?
---@field padding {left: integer, right: integer}?

---@class winbar_t
---@field buf integer
---@field win integer
---@field sources winbar_source_t[]
---@field separator winbar_symbol_t
---@field padding {left: integer, right: integer}
---@field extends winbar_symbol_t
---@field components winbar_symbol_t[]
---@field string_cache string
local winbar_t = {}
winbar_t.__index = winbar_t

---Create a winbar instance
---@param opts winbar_opts_t?
---@return winbar_t
function winbar_t:new(opts)
  local winbar = setmetatable(
    vim.tbl_deep_extend('force', {
      buf = vim.api.nvim_get_current_buf(),
      win = vim.api.nvim_get_current_win(),
      components = {},
      string_cache = '',
      sources = {},
      separator = winbar_symbol_t:new({
        icon = static.icons.AngleRight,
        icon_hl = 'WinBarIconSeparator',
      }),
      extends = winbar_symbol_t:new({
        icon = vim.opt.listchars:get().extends
          or vim.trim(static.icons.Ellipsis),
        icon_hl = 'WinBar',
      }),
      padding = {
        left = 1,
        right = 1,
      },
    }, opts or {}),
    winbar_t
  )
  return winbar
end

---Delete a winbar instance
---@return nil
function winbar_t:del()
  for _, component in ipairs(self.components) do
    component:del()
  end
end

---Get the display length of the winbar
---@return number
function winbar_t:displaywidth()
  return vim.fn.strdisplaywidth(self:cat(true))
end

---Truncate the winbar to fit the window width
---Side effect: change winbar.components
---@return nil
function winbar_t:truncate()
  local win_width = vim.api.nvim_win_get_width(0)
  local len = self:displaywidth()
  local delta = len - win_width
  for _, component in ipairs(self.components) do
    if delta <= 0 then
      break
    end
    local name_len = vim.fn.strdisplaywidth(component.name)
    local min_len =
      vim.fn.strdisplaywidth(component.name:sub(1, 1) .. self.extends.icon)
    if name_len > min_len then
      component.name = vim.fn.strcharpart(
        component.name,
        0,
        math.max(1, name_len - delta - 1)
      ) .. self.extends.icon
      delta = delta - name_len + vim.fn.strdisplaywidth(component.name)
    end
  end
end

---Concatenate winbar into a string with separator and highlight
---@param plain boolean?
---@return string
function winbar_t:cat(plain)
  if vim.tbl_isempty(self.components) then
    return ''
  end
  local result = nil
  for _, component in ipairs(self.components) do
    result = result
        and result .. self.separator:cat(plain) .. component:cat(plain)
      or component:cat(plain)
  end
  -- Must add highlights to padding, else nvim will automatically truncate it
  local padding_hl = not plain and 'WinBar' or nil
  local padding_left = hl(string.rep(' ', self.padding.left), padding_hl)
  local padding_right = hl(string.rep(' ', self.padding.right), padding_hl)
  return result and padding_left .. result .. padding_right or ''
end

---Update winbar components from sources and redraw winbar, supposed to be
---called at CursorMoved, CurosrMovedI, TextChanged, and TextChangedI
---Not updating when executing a macro
---@return nil
function winbar_t:update()
  if vim.fn.reg_executing() ~= '' then
    return self.string_cache -- Do not update when executing a macro
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  for _, component in ipairs(self.components) do
    component:del()
  end
  self.components = {}
  _G.winbar.on_click_callbacks['buf' .. self.buf]['win' .. self.win] = {}
  for _, source in ipairs(self.sources) do
    local symbols = source.get_symbols(self.buf, cursor)
    for _, symbol in ipairs(symbols) do
      symbol.bar_idx = #self.components + 1
      symbol.bar = self
      table.insert(self.components, symbol)
      -- Register on_click callback for each symbol
      if symbol.on_click then
        ---@param min_width integer 0 if no N specified
        ---@param n_clicks integer number of clicks
        ---@param button string mouse button used
        ---@param modifiers string modifiers used
        ---@return nil
        _G.winbar.on_click_callbacks['buf' .. self.buf]['win' .. self.win]['fn' .. symbol.bar_idx] = function(
          min_width,
          n_clicks,
          button,
          modifiers
        )
          symbol:on_click(min_width, n_clicks, button, modifiers)
        end
      end
    end
  end

  self:truncate()
  self.string_cache = self:cat()
  vim.cmd.redrawstatus()
end

---Get the string representation of the winbar
---@return string
function winbar_t:__tostring()
  if vim.tbl_isempty(self.components) then
    self:update()
  end
  return self.string_cache
end

return {
  winbar_t = winbar_t,
  winbar_symbol_t = winbar_symbol_t,
}
