local static = require('utils.static')

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

---@class winbar_opts_t
---@field sources string[]?
---@field separator winbar_symbol_t?
---@field extends winbar_symbol_t?

---@class winbar_t
---@field sources table
---@field separator winbar_symbol_t
---@field extends winbar_symbol_t
---@field components winbar_symbol_t[]
---@field string_cache string
---@field new fun(table): winbar_t
---@field displen fun(): number
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
      sources = {
        'path',
        {
          'treesitter',
          fallbacks = { 'lsp' },
        },
      },
      separator = winbar_symbol_t:new({
        icon = ' ' .. static.icons.AngleRight,
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
function winbar_t:concat(add_hl)
  if vim.tbl_isempty(self.components) then
    return ''
  end
  add_hl = add_hl == nil and true or add_hl
  local result = nil
  for _, component in ipairs(self.components) do
    -- Do not concat if str is empty or contains only white spaces
    if not component.name:match('^%s*$') then
      local sep_icon = not add_hl and self.separator.icon
        or hl(self.separator.icon, self.separator.icon_hl)
      local component_icon = not add_hl and component.icon
        or hl(component.icon, component.icon_hl)
      local component_name = not add_hl and component.name
        or hl(component.name, component.name_hl)
      local component_str = vim.trim(component_icon .. component_name)
      result = result and result .. sep_icon .. component_str or component_str
    end
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
    if type(source) == 'string' then
      local source_module = require('plugin.winbar.sources.' .. source)
      local components = source_module.get_symbols(buf, cursor)
      vim.list_extend(self.components, components)
    elseif type(source) == 'table' then
      local source_module = require('plugin.winbar.sources.' .. source[1])
      local components = source_module.get_symbols(buf, cursor)
      if components and not vim.tbl_isempty(components) then
        vim.list_extend(self.components, components)
      elseif source.fallbacks then
        for _, fallback in ipairs(source.fallbacks) do
          local fallback_module = require('plugin.winbar.sources.' .. fallback)
          local fallback_components = fallback_module.get_symbols(buf, cursor)
          if
            fallback_components and not vim.tbl_isempty(fallback_components)
          then
            vim.list_extend(self.components, fallback_components)
            break
          end
        end
      end
    end
  end

  if truncate then
    self:truncate()
  end
  self.string_cache = ' ' .. self:concat(add_hl) .. ' '
  return self.string_cache
end

return {
  winbar_t = winbar_t,
  winbar_symbol_t = winbar_symbol_t,
}
