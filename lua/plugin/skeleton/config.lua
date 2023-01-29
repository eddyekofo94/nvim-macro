local M = {}

---@class skeleton_config_t
---@field skeldir string skeleton directory under config directory
---@field proj_skeldir string skeleton directory name under project root directory
---@field apply table<string, boolean> apply to new files / empty existing files
---@field rules table<string, table<string, any>> rules for each filetype
M.config = {
  skeldir = vim.fn.stdpath('config') .. '/skeleton',
  proj_skeldir = '.skeleton',
  apply = {
    new_files = true,
    empty_files = true,
  },
}

return M
