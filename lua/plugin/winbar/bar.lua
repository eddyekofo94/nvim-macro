local static = require('utils.static')

---@class winbar_symbol_t
---@field name string
---@field icon string
---@field name_hl string
---@field icon_hl string

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
---@field sources string[]
---@field separator winbar_symbol_t
---@field extends winbar_symbol_t

---@class winbar_t
---@field sources table
---@field separator winbar_symbol_t
---@field extends winbar_symbol_t
---@field components winbar_symbol_t[]
---@field new fun(table): winbar_t
---@field displen fun(): number
---@operator call: string
---@operation tostring: string
local winbar_t = {}

---Create a winbar instance
---@param opts winbar_opts_t?
---@return winbar_t
function winbar_t:new(opts)
  local winbar = setmetatable(
    vim.tbl_deep_extend('force', {
      components = {},
      sources = {
        'path',
        { 'lsp', fallbacks = { 'treesitter' } },
      },
      separator = {
        icon = ' ' .. static.icons.ArrowRight,
        icon_hl = 'WinBarIconSeparator',
      },
      extends = {
        icon = vim.opt.listchars:get().extends or '…',
        icon_hl = 'WinBar',
      },
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
      component.name = component.name:sub(
        1,
        -math.min(delta + 2, #component.name)
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
      result = result
          and result .. sep_icon .. component_icon .. component_name
        or component_icon .. component_name
    end
  end
  return result or ''
end

---Update the components and return the string representation of the winbar
---@param add_hl boolean? default true
---@param truncate boolean? default true
---@return string
function winbar_t:__call(add_hl, truncate)
  add_hl = add_hl == nil and true or add_hl
  truncate = truncate == nil and true or truncate
  local buf = vim.api.nvim_get_current_buf()
  self.components = {}
  for _, source in ipairs(self.sources) do
    if type(source) == 'string' then
      local source_module = require('plugin.winbar.sources.' .. source)
      local components = source_module.get_symbols(buf)
      vim.list_extend(self.components, components)
    elseif type(source) == 'table' then
      local source_module = require('plugin.winbar.sources.' .. source[1])
      local components = source_module.get_symbols(buf)
      if components and not vim.tbl_isempty(components) then
        vim.list_extend(self.components, components)
      elseif source.fallbacks then
        for _, fallback in ipairs(source.fallbacks) do
          local fallback_module = require('plugin.winbar.sources.' .. fallback)
          local fallback_components = fallback_module.get_symbols(buf)
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
  return ' ' .. self:concat(add_hl) .. ' ' -- Add one-space padding
end

---@param key string|number
function winbar_t:__index(key)
  return winbar_t[key]
end

return {
  winbar_t = winbar_t,
}