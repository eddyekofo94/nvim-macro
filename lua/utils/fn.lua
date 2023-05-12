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

---Convert a snake_case string to camelCase
---@param str string
---@return string|nil
local function snake_to_camel(str)
  if not str then
    return nil
  end
  return (
    str:gsub('^%l', string.upper):gsub('_%l', string.upper):gsub('_', '')
  )
end

---Convert a camelCase string to snake_case
---@param str string
---@return string|nil
local function camel_to_snake(str)
  if not str then
    return nil
  end
  return (str:gsub('%u', '_%1'):gsub('^_', ''):lower())
end

---Check if the current line is a markdown code block
---@param lines string[]
local function markdown_in_code_block(lines)
  local result = false
  for _, line in ipairs(lines) do
    if line:match('^```') then
      result = not result
    end
  end
  return result
end

return {
  proj_dir = proj_dir,
  snake_to_camel = snake_to_camel,
  camel_to_snake = camel_to_snake,
  markdown_in_code_block = markdown_in_code_block,
}
