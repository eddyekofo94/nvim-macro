local bar = require('plugin.winbar.bar')
local menu = require('plugin.winbar.menu')
local static = require('utils.static')

---@alias winbar_symbol_range_t lsp_range_t

---For unify the symbols from different sources
---@class winbar_symbol_tree_t
---@field name string
---@field kind string
---@field children winbar_symbol_tree_t[]?
---@field range winbar_symbol_range_t?
local winbar_symbol_tree_t = {}

function winbar_symbol_tree_t:__index(k)
  ---@diagnostic disable-next-line: undefined-field
  return winbar_symbol_tree_t[k] or self._orig[k]
end

---Crease a new winbar source symbol from obj
---@param convert fun(...): winbar_symbol_tree_t
---@return winbar_symbol_tree_t
function winbar_symbol_tree_t:new(convert, ...)
  local symbol = convert(...)
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
    data = {
      menu = {
        symbol = self,
        symbols_list = self.children,
      },
    },
    ---@param this winbar_symbol_t
    on_click = function(this, _, _, _, _)
      -- If currently inside a menu, highlight the current line
      if this.entry and this.entry.menu then
        this.entry.menu:hl_line_single(this.entry.idx)
      end
      -- Toggle menu on click, create one if not exist
      -- Return if no symbol in list
      if
        not this.data.menu.symbols_list
        or vim.tbl_isempty(this.data.menu.symbols_list)
      then
        return
      end
      -- Create menu if not exist
      if not this.menu then
        -- Create a new menu for the symbol
        this.menu = menu.winbar_menu_t:new({
          prev_win = this.bar and this.bar.win,
          cursor = this.data.menu.idx and { this.data.menu.idx, 0 },
          ---@param source_symbol winbar_symbol_tree_t
          entries = vim.tbl_map(function(source_symbol)
            local symbol_has_children = source_symbol.children
              and not vim.tbl_isempty(source_symbol.children)
            local symbol_indicator_icon = symbol_has_children
                and static.icons.ui.AngleRight
              or string.rep(
                ' ',
                vim.fn.strdisplaywidth(static.icons.ui.AngleRight)
              )
            local symbol_indicator_on_click = nil
            if not symbol_has_children then
              symbol_indicator_on_click = false
            end
            return menu.winbar_menu_entry_t:new({
              components = {
                -- Indicator to show if the symbol has children
                source_symbol:to_winbar_symbol({
                  name = '',
                  icon = symbol_indicator_icon,
                  icon_hl = 'WinBarIconSeparator',
                  on_click = symbol_indicator_on_click,
                }),
                -- Icon and texts for the LSP symbol
                source_symbol:to_winbar_symbol({
                  ---Goto the location of the symbol on click
                  ---@param this winbar_symbol_t
                  ---@diagnostic disable-next-line: redefined-local
                  on_click = function(this, _, _, _, _)
                    local dest_pos = this.data.menu.symbol.range.start
                    local current_menu = this.entry.menu
                    while current_menu and current_menu.parent_menu do
                      current_menu = current_menu.parent_menu
                    end
                    if current_menu then
                      vim.api.nvim_win_set_cursor(current_menu.prev_win, {
                        dest_pos.line + 1,
                        dest_pos.character,
                      })
                      current_menu:close()
                    end
                  end,
                }),
              },
            })
          end, this.data.menu.symbols_list),
        })
      end
      this.menu:toggle()
    end,
  }, opts or {}))
end

return {
  winbar_source_symbol_t = winbar_symbol_tree_t,
}
