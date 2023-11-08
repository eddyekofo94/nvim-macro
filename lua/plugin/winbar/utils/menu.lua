local M = {}

---Get winbar menu
--- - If `opts.win` is specified, return the winbar menu attached the window;
--- - If `opts.win` is not specified, return all opened winbar menus
---@param opts {win: integer?}?
---@return (winbar_menu_t?)|table<integer, winbar_menu_t>
function M.get(opts)
  opts = opts or {}
  if opts.win then
    return _G.winbar.menus[opts.win]
  end
  return _G.winbar.menus
end

---Get current menu
---@return winbar_menu_t?
function M.get_current()
  return M.get({ win = vim.api.nvim_get_current_win() })
end

---Call method on winbar menu(s) given the window id
--- - If `opts.win` is specified, call the winbar menu with the window id;
--- - If `opts.win` is not specified, call all opened winbars
--- - `opts.params` specifies params passed to the method
---@param method string
---@param opts {win: integer?, params: table?}?
---@return any?: return values of the method
function M.exec(method, opts)
  opts = opts or {}
  opts.params = opts.params or {}
  local menus = M.get(opts)
  if not menus or vim.tbl_isempty(menus) then
    return
  end
  if opts.win then
    return menus[method](menus, unpack(opts.params))
  end
  local results = {}
  for _, menu in pairs(menus) do
    table.insert(results, {
      menu[method](menu, opts.params),
    })
  end
  return results
end

---@type winbar_menu_t?
local last_hovered_menu = nil

---Update menu hover highlights given the mouse position
---@param mouse table
---@return nil
function M.update_hover_hl(mouse)
  local menu = M.get({ win = mouse.winid })
  if not menu or mouse.line <= 0 or mouse.column <= 0 then
    if last_hovered_menu then
      last_hovered_menu:update_hover_hl()
      last_hovered_menu = nil
    end
    return
  end
  if last_hovered_menu and last_hovered_menu ~= menu then
    last_hovered_menu:update_hover_hl()
  end
  menu:update_hover_hl({ mouse.line, mouse.column - 1 })
  last_hovered_menu = menu
end

---@type winbar_menu_t?
local last_previewed_menu = nil

---Update menu preview given the mouse position
---@param mouse table
---@return nil
function M.update_preview(mouse)
  local menu = M.get({ win = mouse.winid })
  if not menu or mouse.line <= 0 or mouse.column <= 0 then
    if last_previewed_menu then
      last_previewed_menu:finish_preview()
      last_previewed_menu = nil
    end
    return
  end
  if last_previewed_menu and last_previewed_menu ~= menu then
    last_previewed_menu:finish_preview()
  end
  menu:preview_symbol_at({ mouse.line, mouse.column - 1 }, true)
  last_previewed_menu = menu
end

return M
