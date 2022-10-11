local M = {}

-- Jump to last accessed window on closing the current one
M.win_close_jmp = function()
  -- Exclude floating windows
  if '' ~= vim.api.nvim_win_get_config(0).relative then return end
  -- Record the window we jump from (previous) and to (current)
  if nil == vim.t.winid_rec then
    vim.t.winid_rec = { prev = vim.fn.win_getid(), current = vim.fn.win_getid() }
  else
    vim.t.winid_rec = { prev = vim.t.winid_rec.current, current = vim.fn.win_getid() }
  end
  -- Loop through all windows to check if the previous one has been closed
  for winnr = 1, vim.fn.winnr('$') do
    if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
      return -- Return if previous window is not closed
    end
  end
  vim.cmd [[ wincmd p ]]
end

-- Last-position-jump
-- Source: https://www.reddit.com/r/neovim/comments/ucgxmj/comment/i6coai3/?utm_source=share&utm_medium=web2x&context=3
M.last_pos_jmp = function()
  local ft = vim.opt_local.filetype:get()
  -- don't apply to git messages
  if (ft:match('commit') or ft:match('rebase')) then
    return
  end
  -- get position of last saved edit
  local markpos = vim.api.nvim_buf_get_mark(0, '"')
  local line = markpos[1]
  local col = markpos[2]
  -- if in range, go there
  if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
    vim.api.nvim_win_set_cursor(0, { line, col })
  end
end

-- Source: https://github.com/wookayin/dotfiles/commit/96d935515486f44ec361db3df8ab9ebb41ea7e40
M.close_all_floatings = function(key)
  local count = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      count = count + 1
    end
  end
  if count == 0 then  -- Fallback
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(key, true, true, true), 'nt', true)
  end
end

-- Check if a plugin is loaded
M.loaded = function(plugin)
  return packer_plugins[plugin] and packer_plugins[plugin].loaded
end

-- Force expandtab temporarily if have texts before cursor.
-- Restore expandtab setting with an autocmd, see autocmd.lua.
M.tab_space_switch = function()
  -- Need not to check mode because the function will
  -- be called only in insert mode.
  local x = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  -- The offset of the last text before the cursor,
  -- if have no test before the cursor, text_offset will be -1.
  local text_offset = vim.fn.match(line:sub(1, x):reverse(), [[\S]])

  -- Find if there's an adjacent tab.
  -- An adjacent tab is a tab that:
  --  1. Located before and within 1 tabstop of the cursor, with
  --     no non-whitespace character in between the tab and the cursor.
  --  2. Or located right after the cursor.
  -- About what defines an adjacent tab, consider the following cases,
  -- assuming softtabstop (or its fallback value) is 2 and tabstop is 4:
  -- Case 1: │→               adjacent
  -- Case 2: │⌴→          not adjacent
  -- Case 3: │t→          not adjacent
  -- Case 4: →   t│       not adjacent
  -- Case 5: t→    ⌴│         adjacent
  -- Case 6: t→    ⌴⌴│        adjacent
  -- Case 7: t→    ⌴⌴⌴│       adjacent
  -- Case 8: t→    ⌴⌴⌴⌴│  not adjacent
  -- '→   ' -- tab
  -- 't'    -- text character
  -- '│'    -- cursor
  -- '⌴'    -- space
  local match_start = x - vim.bo.ts
  if match_start < 0 then match_start = 0 end
  local tab_offset = vim.fn.match(line:sub(match_start+1, x):reverse(), [[\t]])
  local adjacent_tab = line:sub(x, x) == '\t'
                       or line:sub(x+1, x+1) == '\t'
                       or tab_offset >= 0
                          and text_offset >= 0
                          and tab_offset < text_offset
  -- Force expandtab if have text before the cursor
  -- and no adjacent tab is present
  if text_offset >= 0 and not adjacent_tab then
    -- Store old expandtab setting in a buffer-scoped variable,
    -- the autocmd will use it to restore the expandtab setting.
    vim.b.old_expandtab = vim.bo.expandtab
    vim.bo.expandtab = true
  end
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'nt', true)
end

M.git_dir = function ()
local gitdir = vim.fn.system(string.format(
  'git -C %s rev-parse --show-toplevel', vim.fn.expand('%:p:h')))
local isgitdir = vim.fn.matchstr(gitdir, '^fatal:.*') == ''
if not isgitdir then return end
return vim.trim(gitdir)
end

return M
