local function is_border_win(motion_key)
  return vim.fn.winnr() == vim.fn.winnr('1' .. motion_key)
end

local function resize_left(count)
  if is_border_win('l') then
    vim.cmd('vertical resize +' .. count)
  else
    vim.fn.win_move_separator(0, -count)
  end
end

local function resize_right(count)
  if is_border_win('l') then
    vim.cmd('vertical resize -' .. count)
  else
    vim.fn.win_move_separator(0, count)
  end
end

local function resize_up(count)
  if is_border_win('j') then
    vim.cmd('horizontal resize +' .. count)
  else
    vim.fn.win_move_statusline(0, -count)
  end
end

local function resize_down(count)
  if is_border_win('j') then
    vim.cmd('horizontal resize -' .. count)
  else
    vim.fn.win_move_statusline(0, count)
  end
end

return {
  resize_left = resize_left,
  resize_right = resize_right,
  resize_up = resize_up,
  resize_down = resize_down,
}
