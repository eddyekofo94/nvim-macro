local M = {}

---@class skeleton_config_t
---@field skeleton_dir string skeleton directory under config directory
---@field skeleton_proj_dirname string skeleton directory name under project root directory
---@field rules table<string, { cond: function }> filename patterns and apply conditions
M.config = {
  skeleton_dir = vim.fn.stdpath('config') .. '/skeleton',
  skeleton_proj_dirname = '/.skeleton',
}

return M
