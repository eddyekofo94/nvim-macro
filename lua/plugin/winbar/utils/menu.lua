local M = {}

---Get winbar menu
--- - If `opts.win` is specified, return the winbar menu attached the window;
--- - If `opts.win` is not specified, return all opened winbar menus
---@param opts {win: integer?}?
---@return table<integer, winbar_menu_t>|winbar_menu_t?
function M.get(opts)
  opts = opts or {}
  if opts.win then
    return _G.winbar.menus[opts.win]
  end
  return _G.winbar.menus
end

---Call method on winbar menu(s) given the window id
--- - If `opts.win` is specified, call the winbar menu with the window id;
--- - If `opts.win` is not specified, call all opened winbars
---@param opts {win: integer?}?
---@param method string
---@vararg any? params passed to the method
---@return any? return value of the method
function M.exec(opts, method, ...)
  opts = opts or {}
  local menus = M.get(opts)
  if not menus or vim.tbl_isempty(menus) then
    return
  end
  if opts.win then
    return menus[method](menus, ...)
  end
  local results = {}
  for _, menu in pairs(menus) do
    table.insert(results, { menu[method](menu, ...) })
  end
  return results
end

return M
