local M = {}

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
  return function(tabpage, clear)
    tabpage = tabpage and tabpage ~= 0 and tabpage
      or vim.api.nvim_get_current_tabpage()
    if not store[tabpage] then
      return
    end
    for win, data in pairs(store[tabpage]) do
      pcall(vim.api.nvim_win_call, win, function()
        callback(win, data)
      end)
    end
    if clear then
      store[tabpage] = nil
    end
  end
end

local tabpage_views = {}
local tabpage_heights = {}

-- stylua: ignore start
M.tabpage_saveview = M.tabpage_save(function(_) return vim.fn.winsaveview() end, tabpage_views)
M.tabpage_restview = M.tabpage_rest(function(_, view) vim.fn.winrestview(view) end, tabpage_views)
M.tabpage_saveheight = M.tabpage_save(vim.api.nvim_win_get_height, tabpage_heights)
M.tabpage_restheight = M.tabpage_rest(vim.api.nvim_win_set_height, tabpage_heights)
-- stylua: ignore end

return M
