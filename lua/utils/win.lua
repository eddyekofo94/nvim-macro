local M = {}

---@type table<integer, table<integer, vim.fn.winsaveview.ret>>
local tabpage_views = {}

---Save the view of all windows in current tabpage
---@param tabpage integer? default to current tabpage
---@return nil
function M.tabpage_saveview(tabpage)
  tabpage = tabpage and tabpage ~= 0 and tabpage
    or vim.api.nvim_get_current_tabpage()
  local views = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
    views[win] = vim.api.nvim_win_call(win, function()
      return vim.fn.winsaveview()
    end)
  end
  tabpage_views[tabpage] = views
end

---Restore the view of all windows in current tabpage
---@param tabpage integer? default to current tabpage
---@param clear boolean? whether to clear the saved views after restoring
---@return nil
function M.tabpage_restview(tabpage, clear)
  tabpage = tabpage and tabpage ~= 0 and tabpage
    or vim.api.nvim_get_current_tabpage()
  if not tabpage_views[tabpage] then
    return
  end
  for win, view in pairs(tabpage_views[tabpage]) do
    pcall(vim.api.nvim_win_call, win, function()
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.fn.winrestview(view)
    end)
  end
  if clear then
    tabpage_views[tabpage] = nil
  end
end

return M
