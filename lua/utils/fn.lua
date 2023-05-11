---Compute project directory for given path.
---@param fpath string
---@return string|nil
local function proj_dir(fpath)
  if not fpath or fpath == '' then
    return nil
  end
  local root_patterns = {
    '.git',
    '.svn',
    '.bzr',
    '.hg',
    '.project',
    '.pro',
    '.sln',
    '.vcxproj',
    '.editorconfig',
  }
  local dirpath = vim.fs.dirname(fpath)
  local root = vim.fs.find(root_patterns, {
    path = dirpath,
    upward = true,
  })[1]
  if root and vim.loop.fs_stat(root) then
    return vim.fs.dirname(root)
  end
  if dirpath then
    local dirstat = vim.loop.fs_stat(dirpath)
    if dirstat and dirstat.type == 'directory' then
      return dirpath
    end
  end
  return nil
end

return {
  proj_dir = proj_dir,
}
