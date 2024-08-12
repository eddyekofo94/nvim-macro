local M = {}

local utils_fs = require "utils.fs"
local TelescopePickers = require "utils.telescope_pickers"

-- We cache the results of "git rev-parse"
-- Process creation is expensive in Windows, so this reduces latency
local is_inside_work_tree = {}

local function is_git_repo()
  vim.fn.system "git rev-parse --is-inside-work-tree"

  return vim.v.shell_error == 0
end

local function live_grep_from_project_git_root()
  local function is_git_repo()
    vim.fn.system "git rev-parse --is-inside-work-tree"

    return vim.v.shell_error == 0
  end

  local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
  end

  local opts = {}

  if is_git_repo() then
    opts = {
      cwd = get_git_root(),
    }
  end

  require("telescope.builtin").live_grep(opts)
end

-- this will return a function that calls telescope.
-- cwd will default to utils.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.find(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = utils_fs:get_root() }, opts or {})

    if builtin == "files" then
      return M.project_files(opts)
    end

    -- if builtin == 'buffers' then
    --   return TelescopePickers.pretty_buffers_picker(opts)
    -- end
    if builtin == "live_grep" then
      return TelescopePickers.live_grep(opts)
    end
    if builtin == "grep_string" then
      return TelescopePickers.grep_string(opts)
    end

    if opts.cwd ~= vim.uv.cwd() then
      local function open_cwd_dir()
        local action_state = require "telescope.actions.state"
        local line = action_state.get_current_line()
        M.find(params.builtin, vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line }))()
      end
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        -- opts.desc is overridden by telescope, until it's changed there is this fix
        map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd directory" })
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

M.project_files = function(opts)
  local builtin = require "telescope.builtin"

  local cwd = (opts.cwd or vim.uv.cwd())
  if is_inside_work_tree[cwd] == nil then
    vim.fn.system "git rev-parse --is-inside-work-tree"
    is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end

  -- if not is_inside_work_tree[cwd] then
  if vim.uv.fs_stat(cwd .. "/.git") then
    opts.show_untracked = true
    opts.no_ignore = false
    builtin["git_files"](opts)
    -- builtin = TelescopePickers.pretty_files_picker("git_files", opts)
  else
    builtin["find_files"](opts)
    -- builtin = TelescopePickers.pretty_files_picker("find_files", opts)
  end
  return builtin
end

M.send_to_harpoon_action = function(prompt_bufnr)
  local actions_state = require "telescope.actions.state"
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local ok, mark = pcall(require, "harpoon.mark")

  if not ok then
    return
  end

  if #picker:get_multi_selection() < 1 then
    mark.add_file(picker:get_selection()[1])
    return
  end

  for _, entry in ipairs(picker:get_multi_selection()) do
    mark.add_file(entry[1])
  end
end

function M.config_files()
  return M.find("find_files", { cwd = vim.fn.stdpath "config" })
end

function M.dotfiles()
  return M.find("git_files", { cwd = os.getenv "HOME" .. "/.dotfiles/", follow = true, no_ignore = true, hidden = true })
end

return M
