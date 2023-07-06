local M = {}

---Get winbar menu has winid `opts.win` or has prev_win `opts.prev_win`
---@param opts {win: integer?, prev_win: integer?}
---@return winbar_menu_t?
function M.get_menu(opts)
  opts = opts or {}
  if opts.win and _G.winbar.menus then
    return _G.winbar.menus[opts.win]
  end
  if opts.prev_win and _G.winbar.menus_prev_win then
    return _G.winbar.menus_prev_win[opts.prev_win]
  end
end

return M
