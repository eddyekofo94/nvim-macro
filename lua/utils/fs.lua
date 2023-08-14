local M = {}

M.root_patterns = {
  '.git/',
  '.svn/',
  '.bzr/',
  '.hg/',
  '.project/',
  '.pro',
  '.sln',
  '.vcxproj',
  'Makefile',
  'makefile',
  'MAKEFILE',
  '.gitignore',
  '.editorconfig',
}

---Compute project directory for given path.
---@param fpath string?
---@param patterns string[]? root patterns
---@return string? nil if not found
function M.proj_dir(fpath, patterns)
  if not fpath or fpath == '' then
    return nil
  end
  patterns = patterns or M.root_patterns
  local dirpath = vim.fs.dirname(fpath)
  for _, pattern in ipairs(patterns) do
    local root = vim.fs.find(pattern, {
      path = dirpath,
      upward = true,
      type = pattern:match('/$') and 'directory' or 'file',
    })[1]
    if root and vim.uv.fs_stat(root) then
      return vim.fs.dirname(root)
    end
  end
end

return M
