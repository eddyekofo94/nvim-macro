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

---Generate a function to save some attributes of all windows
---in current tabpage
---@param callback fun(win: integer): any?
---@param store table<integer, any>
---@return fun(tabpage: integer?): nil
function M.tabpage_save(callback, store)
  return function(tabpage)
    tabpage = tabpage and tabpage ~= 0 and tabpage
      or vim.api.nvim_get_current_tabpage()
    local views = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      views[win] = vim.api.nvim_win_call(win, function()
        return callback(win)
      end)
    end
    store[tabpage] = views
  end
end

---Generate a function to reset the attributes to all windows
---in current tabpage
---@param callback fun(win: integer, data: any): any?
---@param store table<integer, any>
---@return fun(tabpage: integer?, clear: boolean?): nil
function M.tabpage_rest(callback, store)
  return function(tabpage)
    tabpage = tabpage and tabpage ~= 0 and tabpage
      or vim.api.nvim_get_current_tabpage()
    if not store[tabpage] then
      return
    end
    for win, data in pairs(store[tabpage]) do
      if not vim.api.nvim_win_is_valid(win) then
        store[tabpage][win] = nil
      else
        pcall(vim.api.nvim_win_call, win, function()
          callback(win, data)
        end)
      end
    end
  end
end

---Generate a function to clear the attributes of all windows
---in a tabpage
---@param store table<integer, any>
---@return fun(tabpage: integer?): nil
function M.tabpage_clear(store)
  return function(tabpage)
    tabpage = tabpage and tabpage ~= 0 and tabpage
      or vim.api.nvim_get_current_tabpage()
    store[tabpage] = nil
  end
end

local tabpage_ratio = {}
local tabpage_views = {}
local tabpage_heights = {}

M.tabpage_clearratio = M.tabpage_clear(tabpage_ratio)
M.tabpage_clearviews = M.tabpage_clear(tabpage_views)
M.tabpage_clearheights = M.tabpage_clear(tabpage_heights)

-- stylua: ignore start
M.tabpage_saveviews = M.tabpage_save(function(_) return vim.fn.winsaveview() end, tabpage_views)
M.tabpage_restviews = M.tabpage_rest(function(_, view) vim.fn.winrestview(view) end, tabpage_views)
M.tabpage_saveheights = M.tabpage_save(vim.api.nvim_win_get_height, tabpage_heights)
M.tabpage_restheights = M.tabpage_rest(M.win_safe_set_height, tabpage_heights)
-- stylua: ignore end

---Save window ratio in current tabpage as { height_ratio, width_ratio } tuple
---@return nil
M.tabpage_saveratio = M.tabpage_save(function(win)
  return {
    vim.api.nvim_win_get_height(win) / vim.go.lines,
    vim.api.nvim_win_get_width(win) / vim.go.columns,
  }
end, tabpage_ratio)

---Restore window ratio in current tabpage
---@return nil
M.tabpage_restratio = M.tabpage_rest(function(win, ratio)
  local h = type(ratio[1]) == 'table' and ratio[1][vim.val_idx] or ratio[1]
  local w = type(ratio[2]) == 'table' and ratio[2][vim.val_idx] or ratio[2]
  M.win_safe_set_height(win, vim.fn.round(vim.go.lines * h))
  vim.api.nvim_win_set_width(win, vim.fn.round(vim.go.columns * w))
end, tabpage_ratio)

return M
