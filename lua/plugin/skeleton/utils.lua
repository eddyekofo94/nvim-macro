local M = {}
local fn = vim.fn
local fs = vim.fs
local config = require('plugin.skeleton.config').config

---Select skeleton file from a list of candidates.
---@param fname string name of the new file
---@param dir string direcotry of the new file
---@param skeletons string[] list of names of skeleton files
---@param skeleton_dir string directory where the skeleton file is located
---@return string|boolean skeleton file path or false if no skeleton is found
function M.skeleton_fallback(fname, dir, skeletons, skeleton_dir)
  for _, skeleton in ipairs(skeletons) do
    if M.test_apply_cond(fname, dir, skeleton) and
        fn.filereadable(skeleton_dir .. '/' .. skeleton) == 1 then
      return skeleton_dir .. '/' .. skeleton
    end
  end

  return false
end

---Given the name of the new file, find the list of skeleton files that
---is configured with explicit rules.
---@param fname string name of the new file
---@return string[] list of names of skeleton files
function M.get_skeletons_configured(fname)
  if not config or not config.rules or vim.tbl_isempty(config.rules) then
    return {}
  end

  for pattern, skeletons in pairs(config.rules) do
    if fn.match(fname, pattern) ~= -1 then
      local skeleton_list = {}
      for skeleton, _ in pairs(skeletons) do
        table.insert(skeleton_list, skeleton)
      end
      return skeleton_list
    end
  end

  return {}
end

---Given the name and directory of the new file, check if a skeleton file
---should be applied.
---@param fname string name of the new file
---@param dir string directory of the new file, not necessarily the project dir
---@param skeleton string name of the skeleton file
---@return any _ return value of the condition function or true
function M.test_apply_cond(fname, dir, skeleton)
  if not config.rules or vim.tbl_isempty(config.rules) then
    return true
  end

  for pattern, skeleton_files in pairs(config.rules) do
    if vim.fn.match(fname, pattern) ~= -1 then
      local cond = skeleton_files[skeleton]
        and skeleton_files[skeleton].cond
      if type(cond) == 'function' then
        return cond(fname, dir)
      else
        if cond == nil then
          return true
        else
          return cond
        end
      end
    end
  end

  return true
end

---Get the extension of a file; fallback to filetype
---@param fname string
---@return string
function M.get_ext(fname)
  local ext = fn.fnamemodify(fname, ':e')
  if ext == '' then
    return vim.bo.ft
  end
  return ext
end

---Find proper skeleton inside skeleton direcotry and apply it.
---@param fname string name of the new file
---@param dir string directory of the new file
---@param skeleton_dir string skeleton directory, default to <project_dir>/.skeleton
---@param candidates nil|string[] list of fallback skeleton files
---@return boolean true if skeleton is applied
function M.apply_skeleton_indir(fname, dir, skeleton_dir, candidates)
  if not skeleton_dir or fn.isdirectory(skeleton_dir) == 0 then
    return false
  end

  local ext = M.get_ext(fname)
  local skeleton = M.skeleton_fallback(fname, dir, candidates or {
    fname,
    'skeleton.' .. fname,
    '.skeleton.' .. fname,
    'skeleton.' .. ext,
    '.skeleton.' .. ext
  }, skeleton_dir)

  local skeleton_sub_dir = skeleton_dir .. '/' .. ext
  if not skeleton and fn.isdirectory(skeleton_sub_dir) == 1 then
    skeleton = M.skeleton_fallback(fname, dir, candidates or {
      fname,
      'skeleton.' .. fname,
      '.skeleton.' .. fname,
      'skeleton.' .. ext,
      '.skeleton.' .. ext,
    }, skeleton_sub_dir)
  end

  if skeleton then
    vim.cmd('0r ' .. skeleton)
    return true
  end

  return false
end

---Find skeleton files in project directory and apply it.
---@param fname string name of the new file
---@param dir string directory of the new file
---@param skeleton_dir string skeleton directory, project directory in this case
---@param candidates nil|string[] fallback skeleton files
---@return boolean true if skeleton is applied
function M.apply_skeleton_bare(fname, dir, skeleton_dir, candidates)
  if not skeleton_dir or fn.isdirectory(skeleton_dir) == 0 then
    return false
  end

  local ext = M.get_ext(fname)
  local skeleton = M.skeleton_fallback(fname, dir, candidates or {
    '.skeleton.' .. fname,
    '.skeleton.' .. ext
  }, skeleton_dir)
  if type(skeleton) == 'string' and fn.filereadable(skeleton) == 1 then
    vim.cmd('0r ' .. skeleton)
    return true
  end

  return false
end

---Apply skeleton to the new file.
---@return boolean true if skeleton is applied
function M.apply_skeleton()
  if not vim.bo.buftype == '' then return false end

  local proj_dir = require('utils.funcs').proj_dir() or ''
  local fname = fn.expand('%:t')
  local fpath = fn.expand('%:p:h')
  local utils = require('plugin.skeleton.utils')
  local skeletons_configured = utils.get_skeletons_configured(fname)

  return M.apply_skeleton_bare(fname, fpath, proj_dir, skeletons_configured)
    or M.apply_skeleton_indir(fname, fpath, proj_dir .. config.skeleton_proj_dirname, skeletons_configured)
    or M.apply_skeleton_indir(fname, fpath, config.skeleton_dir, skeletons_configured)
    or M.apply_skeleton_bare(fname, fpath, proj_dir, nil)
    or M.apply_skeleton_indir(fname, fpath, proj_dir .. config.skeleton_proj_dirname, nil)
    or M.apply_skeleton_indir(fname, fpath, config.skeleton_dir, nil)
end

return M
