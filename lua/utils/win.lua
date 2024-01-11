local M = {}

---Set window height, without affecting cmdheight
---@param win integer window ID
---@param height integer window height
---@return nil
function M.win_safe_set_height(win, height)
  if not vim.api.nvim_win_is_valid(win) then
    return
  end
  local winnr = vim.fn.winnr()
  if vim.fn.winnr('j') ~= winnr or vim.fn.winnr('k') ~= winnr then
    vim.api.nvim_win_set_height(win, height)
  end
end

---Get current 'effective' lines (lines can be used by normal windows)
---@return integer
function M.effective_lines()
  local lines = vim.go.lines
  local ch = vim.go.ch
  local ls = vim.go.ls
  return lines
    - ch
    - (
      ls == 0 and 0
      or (ls == 2 or ls == 3) and 1
      or #vim.tbl_filter(function(win)
        return vim.fn.win_gettype(win) ~= 'popup'
      end, vim.api.nvim_tabpage_list_wins(0))
    )
end

---Returns a function to save some attributes a list of windows
---@param save_method fun(win: integer): any?
---@param store table<integer, any>
---@return fun(wins: integer[]?): nil
function M.save(save_method, store)
  ---@param wins? integer[] list of wins to restore, default to all windows
  return function(wins)
    for _, win in ipairs(wins or vim.api.nvim_list_wins()) do
      store[win] = vim.api.nvim_win_call(win, function()
        return save_method(win)
      end)
    end
  end
end

---Returns a function to restore the attributes of windows from `store`
---@param restore_method fun(win: integer, data: any): any?
---@param store table<integer, any>
---@return fun(wins: integer[]?): nil
function M.rest(restore_method, store)
  ---@param wins? integer[] list of wins to restore, default to all windows
  return function(wins)
    if not store then
      return
    end
    for _, win in pairs(wins or vim.api.nvim_list_wins()) do
      if store[win] then
        if not vim.api.nvim_win_is_valid(win) then
          store[win] = nil
        else
          pcall(vim.api.nvim_win_call, win, function()
            restore_method(win, store[win])
          end)
        end
      end
    end
  end
end

---Returns a function to clear the attributes of all windows in `store`
---@param store table<integer, any>
---@return fun(): nil
function M.clear(store)
  return function()
    for win, _ in ipairs(store) do
      store[win] = nil
    end
  end
end

local views = {}
local ratios = {}
local heights = {}

M.clearviews = M.clear(views)
M.clearratio = M.clear(ratios)
M.clearheights = M.clear(heights)

-- stylua: ignore start
M.saveviews = M.save(function(_) return vim.fn.winsaveview() end, views)
M.restviews = M.rest(function(_, view) vim.fn.winrestview(view) end, views)
M.saveheights = M.save(vim.api.nvim_win_get_height, heights)
M.restheights = M.rest(M.win_safe_set_height, heights)
-- stylua: ignore end

---Save window ratios as { height_ratio, width_ratio } tuple
---@return nil
M.saveratio = M.save(function(win)
  return {
    vim.api.nvim_win_get_height(win) / M.effective_lines(),
    vim.api.nvim_win_get_width(win) / vim.go.columns,
  }
end, ratios)

---Restore window ratios
---@return nil
M.restratio = M.rest(function(win, ratio)
  local h = type(ratio[1]) == 'table' and ratio[1][vim.val_idx] or ratio[1]
  local w = type(ratio[2]) == 'table' and ratio[2][vim.val_idx] or ratio[2]
  M.win_safe_set_height(win, vim.fn.round(M.effective_lines() * h))
  vim.api.nvim_win_set_width(win, vim.fn.round(vim.go.columns * w))
end, ratios)

return M
