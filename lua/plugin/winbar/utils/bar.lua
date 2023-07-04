local M = {}

---Get winbar
---If only `opts.win` is specified, return the winbar attached the window;
---If only `opts.buf` is specified, return all winbars attached the buffer;
---If both `opts.win` and `opts.buf` are specified, return the winbar attached
---the window that contains the buffer;
---If neither `opts.win` nor `opts.buf` is specified, return the winbar
---attached the current window
---@param opts {win: integer?, buf: integer?}
---@return winbar_t|winbar_t[]?
function M.get_winbar(opts)
  opts = opts or {}
  if opts.buf then
    if opts.win then
      return rawget(_G.winbar.bars, opts.buf)
        and rawget(_G.winbar.bars[opts.buf], opts.win)
    end
    return rawget(_G.winbar.bars, opts.buf)
  end
  opts.win = opts.win or vim.api.nvim_get_current_win()
  opts.buf = vim.api.nvim_win_get_buf(opts.win)
  return rawget(_G.winbar.bars, opts.buf)
    and rawget(_G.winbar.bars[opts.buf], opts.win)
end

---@type winbar_t?
local last_hovered_winbar = nil

---Update winbar hover highlights given the mouse position
---@param mouse table
---@return nil
function M.update_hover_hl(mouse)
  local winbar = M.get_winbar({ win = mouse.winid })
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
