local M = {}

M.root_patterns = {
  ".git/",
  ".svn/",
  ".bzr/",
  ".hg/",
  ".project/",
  ".pro",
  ".sln",
  ".vcxproj",
  "Makefile",
  "makefile",
  "MAKEFILE",
  ".gitignore",
  ".editorconfig",
}

---Read file contents
---@param path string
---@return string?
function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local content = file:read "*a"
  file:close()
  return content or ""
end

---Write string into file
---@param path string
---@return boolean success
function M.write_file(path, str)
  local file = io.open(path, "w")
  if not file then
    return false
  end
  file:write(str)
  file:close()
  return true
end

function M.is_new_file()
  local filename = vim.fn.expand "%"
  return filename ~= "" and vim.bo.buftype == "" and vim.fn.filereadable(filename) == 0
end

function M.filename()
  local current = vim.api.nvim_get_current_win()
  local filename = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(current))
  local icon = ""
  local icon_highlight = ""

  if filename ~= "" then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon, icon_hl = devicons.get_icon(filename)
      icon = (ft_icon ~= nil and ft_icon) or icon
      icon_highlight = icon_hl
    end
    filename = vim.fn.fnamemodify(filename, ":~:.")
    filename = string.format("%s%s", icon .. " ", filename)
  else
    filename = string.format(" %s%s ", icon, vim.bo.filetype):upper()
  end

  return filename, icon_highlight
end

function M.is_git_repo()
  vim.fn.system "git rev-parse --is-inside-work-tree"

  return vim.v.shell_error == 0
end

---@param path string
---@param sep string path separator
---@param max_len integer maximum length of the full filename string
---@return string
function M.shorten_path(path, sep, max_len)
  local len = #path
  if len <= max_len then
    return path
  end

  local segments = vim.split(path, sep)

  if M.is_git_repo() and max_len == 0 then
    return segments[#segments]
  end

  for idx = 1, #segments - 1 do
    if len <= max_len then
      break
    end

    local segment = segments[idx]
    local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
    segments[idx] = shortened
    len = len - (#segment - #shortened)
  end

  return table.concat(segments, sep)
end

function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)

  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.uv.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.uv.cwd()
  end
  ---@cast root string
  return root
end

---Compute project directory for given path.
---@param path string?
---@param patterns string[]? root patterns
---@return string? nil if not found
function M.cwd_dir(path, patterns)
  if not path or path == "" then
    return nil
  end
  patterns = patterns or M.root_patterns
  ---@diagnostic disable-next-line: undefined-field
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return
  end
  local dirpath = stat.type == "directory" and path or vim.fs.dirname(path)
  for _, pattern in ipairs(patterns) do
    local root = vim.fs.find(pattern, {
      path = dirpath,
      upward = true,
      type = pattern:match "/$" and "directory" or "file",
    })[1]
    if root and vim.uv.fs_stat(root) then
      local dirname = vim.fs.dirname(root)
      return dirname and vim.uv.fs_realpath(dirname) --[[@as string]]
    end
  end
end

return M
