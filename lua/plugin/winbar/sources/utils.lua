local bar = require('plugin.winbar.bar')
local menu = require('plugin.winbar.menu')
local static = require('utils.static')

---@alias winbar_symbol_range_t lsp_range_t

---For unify the symbols from different sources
---@class winbar_symbol_tree_t
---@field name string
---@field kind string
---@field children winbar_symbol_tree_t[]?
---@field siblings winbar_symbol_tree_t[]?
---@field idx integer? index of the symbol in its siblings
---@field range winbar_symbol_range_t?
local winbar_symbol_tree_t = {}

function winbar_symbol_tree_t:__index(k)
  ---@diagnostic disable-next-line: undefined-field
  return winbar_symbol_tree_t[k] or self._orig[k]
end

---Crease a new winbar source symbol from ...
---@param unification fun(...): winbar_symbol_tree_t
---@return winbar_symbol_tree_t
function winbar_symbol_tree_t:new(unification, ...)
  local symbol = unification(...)
  return setmetatable({ _orig = symbol }, winbar_symbol_tree_t)
end

---Convert a winbar source symbol to a winbar symbol
---@param opts winbar_symbol_t? extra options to override or pass to winbar_symbol_t:new()
---@return winbar_symbol_t
function winbar_symbol_tree_t:to_winbar_symbol(opts)
  return bar.winbar_symbol_t:new(vim.tbl_deep_extend('force', {
    name = self.name,
    icon = static.icons.kinds[self.kind],
    icon_hl = 'WinBarIconKind' .. self.kind,
    symbol = self,
    ---@param this winbar_symbol_t
    on_click = function(this, _, _, _, _)
      -- If currently inside a menu, highlight the current line
      if this.entry and this.entry.menu then
        this.entry.menu:hl_line_single(this.entry.idx)
      end
      -- Toggle menu on click, or create one if menu don't exist:
      -- 1. If symbol inside a winbar, create a menu with entries containing
      --    the symbol's siblings
      -- 2. Else if symbol inside a menu, create menu with entries containing
      --    the symbol's children
      if this.menu then
        this.menu:toggle()
        return
      end
      if not this.symbol then
        return
      end

      local menu_prev_win = nil ---@type integer?
      local menu_entries_source = nil ---@type winbar_symbol_tree_t[]?
      local menu_cursor_init = nil ---@type integer[]?
      if this.bar then -- If symbol inside a winbar
        menu_prev_win = this.bar and this.bar.win
        menu_entries_source = this.symbol.siblings
        menu_cursor_init = this.symbol.idx and { this.symbol.idx, 0 }
      elseif this.entry and this.entry.menu then -- If symbol inside a menu
        menu_prev_win = this.entry.menu.win
        menu_entries_source = this.symbol.children
      end
      if not menu_entries_source or vim.tbl_isempty(menu_entries_source) then
        return
      end

      this.menu = menu.winbar_menu_t:new({
        prev_win = menu_prev_win,
        cursor = menu_cursor_init,

        ---@param symbol winbar_symbol_tree_t
        entries = vim.tbl_map(function(symbol)
          local menu_indicator_icon = static.icons.ui.AngleRight
          local menu_indicator_on_click = nil
          if not symbol.children or vim.tbl_isempty(symbol.children) then
            menu_indicator_icon =
              string.rep(' ', vim.fn.strdisplaywidth(menu_indicator_icon))
            menu_indicator_on_click = false
          end

          return menu.winbar_menu_entry_t:new({
            components = {
              symbol:to_winbar_symbol({
                name = '',
                icon = menu_indicator_icon,
                icon_hl = 'WinBarMenuIconIndicator',
                on_click = menu_indicator_on_click,
              }),
              symbol:to_winbar_symbol({
                ---Goto the location of the symbol on click
                ---@param winbar_symbol winbar_symbol_t
                on_click = function(winbar_symbol, _, _, _, _)
                  winbar_symbol:goto_start()
                end,
              }),
            },
          })
        end, menu_entries_source),
      })
      this.menu:toggle()
    end,
  }, opts or {}))
end

return {
  winbar_symbol_tree_t = winbar_symbol_tree_t,
}
