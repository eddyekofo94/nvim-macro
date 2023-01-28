local M = {}

---@class skeleton_config_t
---@field skeleton_dir string skeleton directory under config directory
---@field skeleton_proj_dirname string skeleton directory name under project root directory
---@field apply table<string, boolean> apply to new files / empty files
---@field rules table<string, { cond: function }> filename patterns and apply conditions
M.config = {
  skeleton_dir = vim.fn.stdpath('config') .. '/skeleton',
  skeleton_proj_dirname = '/.skeleton',
  apply = {
    new_files = true,
    empty_files = true,
  },
}

return M
