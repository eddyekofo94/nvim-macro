if
  not vim.env.TMUX
  or not vim.env.TMUX_PANE
  or vim.fn.executable('tmux') == 0
  or vim.tbl_isempty(vim.api.nvim_list_uis())
then
  return
end

---@alias nvim_direction_t 'h'|'j'|'k'|'l'
---@alias tmux_direction_t 'L'|'D'|'U'|'R'
---@alias tmux_borderpane_direction_t 'left'|'bottom'|'top'|'right'

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

---Get tmux option value in current pane
---@param opt string tmux pane option
---@return string tmux pane option value
local function tmux_get_pane_opt(opt)
  return (
    tmux_exec(
      string.format(
        "display-message -pt %s '#{%s}'",
        vim.env.TMUX_PANE,
        vim.fn.escape(opt, "'\\")
      )
    ):gsub('\n.*', '')
  )
end

---Set tmux option value in current pane
---@param opt string tmux pane option
---@param val string tmux pane option value
---@return nil
local function tmux_set_pane_opt(opt, val)
  tmux_exec(
    string.format(
      "set -pt %s %s '%s'",
      vim.env.TMUX_PANE,
      opt,
      vim.fn.escape(val, "'\\")
    )
  )
end

---Unset a tmux pane option
---@param opt string tmux pane option
---@return nil
local function tmux_unset_pane_opt(opt)
  tmux_exec(
    string.format(
      "set -put %s '%s'",
      vim.env.TMUX_PANE,
      vim.fn.escape(opt, "'\\")
    )
  )
end

---@return boolean
local function tmux_is_zoomed()
  return tmux_get_pane_opt('window_zoomed_flag') == '1'
end

---@type table<nvim_direction_t, tmux_borderpane_direction_t>
local tmux_pane_position_map = {
  h = 'left',
  j = 'bottom',
  k = 'top',
  l = 'right',
}

---@param direction nvim_direction_t
---@return boolean
local function tmux_at_border(direction)
  return tmux_get_pane_opt('pane_at_' .. tmux_pane_position_map[direction])
    == '1'
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

-- Set @is_vim and register relevant autocmds callbacks if not already
-- in a vim/nvim session
if tmux_get_pane_opt('@is_vim') == '' then
  tmux_set_pane_opt('@is_vim', 'yes')
  local groupid = vim.api.nvim_create_augroup('TmuxNavSetIsVim', {})
  vim.api.nvim_create_autocmd('VimResume', {
    desc = 'Set @is_vim in tmux pane options after vim resumes.',
    group = groupid,
    callback = function()
      tmux_set_pane_opt('@is_vim', 'yes')
    end,
  })
  vim.api.nvim_create_autocmd({ 'VimSuspend', 'VimLeave' }, {
    desc = 'Unset @is_vim in tmux pane options on vim leaving or suspending.',
    group = groupid,
    callback = function()
      tmux_unset_pane_opt('@is_vim')
    end,
  })
end
