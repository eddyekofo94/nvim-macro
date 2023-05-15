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

---@class winbar_symbol_t
---@field name string
---@field icon string
---@field name_hl string?
---@field icon_hl string?
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

---Concatenate inside a winbar symbol to get the final string
---@param add_hl boolean? default true
---@return string
function winbar_symbol_t:cat(add_hl)
  add_hl = add_hl == nil or add_hl
  local name_hl = add_hl and self.name_hl or nil
  local icon_hl = add_hl and self.icon_hl or nil
  return hl(self.icon, icon_hl) .. hl(self.name, name_hl)
end

---@class winbar_opts_t
---@field sources winbar_source_t[]?
---@field separator winbar_symbol_t?
---@field extends winbar_symbol_t?

---@class winbar_t
---@field sources winbar_source_t[]
---@field separator winbar_symbol_t
---@field extends winbar_symbol_t
---@field components winbar_symbol_t[]
---@field string_cache string
---@field new fun(winbar_opts_t?): winbar_t
---@field displen fun(): integer
---@operator call: string
local winbar_t = {}
winbar_t.__index = winbar_t

---Create a winbar instance
---@param opts winbar_opts_t?
---@return winbar_t
function winbar_t:new(opts)
  local winbar = setmetatable(
    vim.tbl_deep_extend('force', {
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
    }, opts or {}),
    winbar_t
  )
  return winbar
end

---Get the display length of the winbar
---@return number
function winbar_t:displen()
  return vim.fn.strdisplaywidth(self(false, false))
end

---Truncate the winbar to fit the window width
---Side effect: change winbar.components
---@return nil
function winbar_t:truncate()
  local win_width = vim.api.nvim_win_get_width(0)
  local len = self:displen()
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
---@param add_hl boolean? default true
---@return string
function winbar_t:cat(add_hl)
  if vim.tbl_isempty(self.components) then
    return ''
  end
  add_hl = add_hl == nil or add_hl
  local result = nil
  for _, component in ipairs(self.components) do
    result = result
        and result .. self.separator:cat(add_hl) .. component:cat(add_hl)
      or component:cat(add_hl)
  end
  return result or ''
end

---Update the components and return the string representation of the winbar
---@param add_hl boolean? default true
---@param truncate boolean? default true
---@return string
function winbar_t:__call(add_hl, truncate)
  if vim.fn.reg_executing() ~= '' then
    return self.string_cache -- Do not update when executing a macro
  end

  add_hl = add_hl == nil and true or add_hl
  truncate = truncate == nil and true or truncate
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  self.components = {}
  for _, source in ipairs(self.sources) do
    vim.list_extend(self.components, source.get_symbols(buf, cursor))
  end

  if truncate then
    self:truncate()
  end
  self.string_cache = ' ' .. self:cat(add_hl) .. ' '
  return self.string_cache
end

return {
  winbar_t = winbar_t,
  winbar_symbol_t = winbar_symbol_t,
}
