local M = {}

---Get winbar
--- - If only `opts.win` is specified, return the winbar attached the window;
--- - If only `opts.buf` is specified, return all winbars attached the buffer;
--- - If both `opts.win` and `opts.buf` are specified, return the winbar attached
---   the window that contains the buffer;
--- - If neither `opts.win` nor `opts.buf` is specified, return all winbars
---   in the form of `table<buf, table<win, winbar_t>>`
---@param opts {win: integer?, buf: integer?}?
---@return winbar_t?|table<integer, winbar_t>|table<integer, table<integer, winbar_t>>
function M.get(opts)
  opts = opts or {}
  if opts.buf then
    if opts.win then
      return rawget(_G.winbar.bars, opts.buf)
        and rawget(_G.winbar.bars[opts.buf], opts.win)
    end
    return rawget(_G.winbar.bars, opts.buf) or {}
  end
  if opts.win then
    local buf = vim.api.nvim_win_get_buf(opts.win)
    return rawget(_G.winbar.bars, buf)
      and rawget(_G.winbar.bars[buf], opts.win)
  end
  return _G.winbar.bars
end

---Call method on winbar(s) given the window id and/or buffer number the
---winbar(s) attached to
--- - If only `opts.win` is specified, call the winbar attached the window;
--- - If only `opts.buf` is specified, call all winbars attached the buffer;
--- - If both `opts.win` and `opts.buf` are specified, call the winbar attached
---   the window that contains the buffer;
--- - If neither `opts.win` nor `opts.buf` is specified, call all winbars
---@param opts {win: integer?, buf: integer?}?
---@param method string
---@vararg any? params passed to the method
---@return any? return value of the method
function M.exec(opts, method, ...)
  opts = opts or {}
  local winbars = M.get(opts)
  if not winbars or vim.tbl_isempty(winbar) then
    return
  end
  if opts.win then
    return winbars[method](winbars, ...)
  end
  if opts.buf then
    local results = {}
    for _, winbar in pairs(winbars) do
      table.insert(results, { winbar[method](winbar, ...) })
    end
    return results
  end
  local results = {}
  for _, buf_winbars in pairs(winbars) do
    for _, winbar in pairs(buf_winbars) do
      table.insert(results, { winbar[method](winbar, ...) })
    end
  end
  return results
end

---@type winbar_t?
local last_hovered_winbar = nil

---Update winbar hover highlights given the mouse position
---@param mouse table
---@return nil
function M.update_hover_hl(mouse)
  local winbar = M.get({ win = mouse.winid })
  if not winbar or mouse.winrow ~= 1 or mouse.line ~= 0 then
    if last_hovered_winbar then
      last_hovered_winbar:update_hover_hl()
      last_hovered_winbar = nil
    end
    return
  end
  if last_hovered_winbar and last_hovered_winbar ~= winbar then
    last_hovered_winbar:update_hover_hl()
  end
  winbar:update_hover_hl(math.max(0, mouse.wincol - 1))
  last_hovered_winbar = winbar
end

return M
