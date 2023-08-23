if
  not vim.env.TMUX
  or not vim.env.TMUX_PANE
  or vim.fn.executable('tmux') == 0
then
  return
end

---@alias nvim_direction_t 'h'|'j'|'k'|'l'
---@alias tmux_direction_t 'L'|'D'|'U'|'R'

---@return string tmux socket path
local function tmux_get_socket()
  return vim.split(vim.env.TMUX, ',')[1]
end

---@param command string tmux command to execute
---@return string tmux command output
local function tmux_exec(command)
  command = string.format('tmux -S %s %s', tmux_get_socket(), command)
  local handle = assert(
    io.popen(command),
    string.format('[tmux-nav]: unable to execute: [%s]', command)
  )
  local result = handle:read('*a')
  handle:close()
  return result
end

---@return boolean
local function tmux_is_zoomed()
  return nil
    ~= tmux_exec("display-message -p '#{window_zoomed_flag}'"):find('1')
end

---@class tmux_window_pane_t
---@field id integer
---@field x integer
---@field y integer
---@field width integer
---@field height integer

---@class tmux_window_layout_t
---@field width integer
---@field height integer
---@field panes table<integer, tmux_window_pane_t>
---@return tmux_window_layout_t?
local function tmux_get_window_layout()
  -- Example layout info string: 5a51,178x41,0,0,31
  local layout_info_str = tmux_exec("display-message -p '#{window_layout}'")
  if not layout_info_str or layout_info_str == '' then
    return
  end

  local layout = {
    width = tonumber(layout_info_str:match('^%w+,(%d+)x%d+')),
    height = tonumber(layout_info_str:match('^%w+,%d+x(%d+)')),
    panes = {},
  }
  for pane_info_str in layout_info_str:gmatch('(%d+x%d+,%d+,%d+,%d+)') do
    local pane_id = tonumber(pane_info_str:match('%d+x%d+,%d+,%d+,(%d+)'))
    if pane_id then
      layout.panes[pane_id] = {
        id = pane_id,
        x = tonumber(pane_info_str:match('%d+x%d+,(%d+),%d+,%d+')),
        y = tonumber(pane_info_str:match('%d+x%d+,%d+,(%d+),%d+')),
        width = tonumber(pane_info_str:match('(%d+)x%d+')),
        height = tonumber(pane_info_str:match('%d+x(%d+)')),
      }
    end
  end
  return layout
end

---@return integer current pane
local function tmux_get_current_pane_id()
  return tonumber(vim.env.TMUX_PANE:match('%d*')) --[[@as integer]]
end

---@param direction nvim_direction_t
---@return boolean
local function tmux_at_border(direction)
  local id = tmux_get_current_pane_id()
  local layout = tmux_get_window_layout()
  if not layout then
    return false
  end

  local pane = layout.panes[id]
  if not pane then
    return false
  end

  if direction == 'x' then
    return pane.x == 0
  elseif direction == 'j' then
    return pane.y + pane.height == layout.height
  elseif direction == 'k' then
    return pane.y == 0
  else
    return pane.x + pane.width == layout.width
  end
end

---@param direction nvim_direction_t
---@return boolean
local function tmux_should_move(direction)
  return not tmux_is_zoomed() and not tmux_at_border(direction)
end

---@type table<nvim_direction_t, tmux_direction_t>
local tmux_direction_map = {
  h = 'L',
  j = 'D',
  k = 'U',
  l = 'R',
}

---@param direction nvim_direction_t
---@param count integer? default to 1
---@return nil
local function tmux_navigate(direction, count)
  count = count or 1
  for _ = 1, count do
    tmux_exec(
      string.format(
        "select-pane -t '%s' -%s",
        vim.env.TMUX_PANE,
        tmux_direction_map[direction]
      )
    )
  end
end

---Set @is_vim to yes in tmux pane options so that tmux knows that the current
---pane is running vim
---@return nil
local function tmux_set_isvim()
  tmux_exec('set -p @is_vim yes')
end

---@return nil
local function tmux_unset_isvim()
  tmux_exec('set -p -u @is_vim')
end

---@param direction nvim_direction_t
---@return boolean
local function nvim_at_border(direction)
  return vim.fn.winnr() == vim.fn.winnr(direction)
end

---@return boolean
local function nvim_in_floating_win()
  return vim.fn.win_gettype() == 'popup'
end

---@param direction nvim_direction_t
---@param count integer? default to 1
---@return nil
local function nvim_navigate(direction, count)
  count = count or 1
  vim.cmd.wincmd(count .. direction)
end

---@param direction nvim_direction_t
---@param count integer? default to 1
---@return nil
local function navigate(direction, count)
  count = count or 1
  if
    (nvim_at_border(direction) or nvim_in_floating_win())
    and tmux_should_move(direction)
  then
    tmux_navigate(direction, count)
  else
    nvim_navigate(direction, count)
  end
end

---@param direction nvim_direction_t
---@return function: rhs of a window navigation keymap
local function navigate_wrap(direction)
  return function()
    navigate(direction, vim.v.count1)
  end
end

vim.keymap.set({ 'n', 'x' }, '<M-h>', navigate_wrap('h'))
vim.keymap.set({ 'n', 'x' }, '<M-j>', navigate_wrap('j'))
vim.keymap.set({ 'n', 'x' }, '<M-k>', navigate_wrap('k'))
vim.keymap.set({ 'n', 'x' }, '<M-l>', navigate_wrap('l'))

tmux_set_isvim()

local groupid = vim.api.nvim_create_augroup('TmuxNavSetIsVim', {})
vim.api.nvim_create_autocmd('VimResume', {
  desc = 'Set @is_vim in tmux pane options after vim resumes.',
  group = groupid,
  callback = tmux_set_isvim,
})
vim.api.nvim_create_autocmd({ 'VimSuspend', 'VimLeave' }, {
  desc = 'Unset @is_vim in tmux pane options on vim leaving or suspending.',
  group = groupid,
  callback = tmux_unset_isvim,
})
