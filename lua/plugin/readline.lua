local M = {}
local api = vim.api
local fn = vim.fn
local map = vim.keymap.set
local col = vim.fn.col
local line = vim.fn.line

---Get character relative to cursor
---@param offset number from cursor
---@return string character
local function get_char(offset)
  if fn.mode() == 'c' then
    local cmdline = fn.getcmdline()
    local pos = fn.getcmdpos()
    return cmdline:sub(pos + offset, pos + offset)
  end
  local current_line = api.nvim_get_current_line()
  return current_line:sub(col('.') + offset, col('.') + offset)
end

---Check if current line is the last line
---@return boolean
local function last_line()
  if fn.mode() == 'c' then
    return true
  end
  return line('.') == line('$')
end

---Check if current line is the first line
---@return boolean
local function first_line()
  if fn.mode() == 'c' then
    return true
  end
  return line('.') == 1
end

---Check if cursor is at the end of the line
---@return boolean
local function end_of_line()
  if fn.mode() == 'c' then
    return fn.getcmdpos() == #fn.getcmdline() + 1
  end
  return col('.') == col('$')
end

---Check if cursor is at the start of the line
---@return boolean
local function start_of_line()
  if fn.mode() == 'c' then
    return fn.getcmdpos() == 1
  end
  return col('.') == 1
end

---Check if cursor is at the middle of the line
---@return boolean
local function mid_of_line()
  if fn.mode() == 'c' then
    local pos = fn.getcmdpos()
    return pos > 1 and pos <= #fn.getcmdline()
  end
  return col('.') > 1 and col('.') < col('$')
end

---Set up key mappings
function M.init()
  map('!', '<C-a>', '<Home>')
  map('!', '<C-e>', '<End>')
  map('!', '<C-d>', '<Del>')

  map('c', '<C-b>', '<Left>')
  map('i', '<C-b>', function()
    if first_line() and start_of_line() then
      return ''
    end
    return start_of_line() and '<Up><End>' or '<Left>'
  end, { expr = true })

  map('c', '<C-f>', '<Right>')
  map('i', '<C-f>', function()
    if last_line() and end_of_line() then
      return ''
    end
    return end_of_line() and '<Down><Home>' or '<Right>'
  end, { expr = true })

  map('c', '<C-k>', '<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>')
  map('i', '<C-k>', function()
    return end_of_line() and '<Del>' or '<C-o>D'
  end, { expr = true })

  map('!', '<C-t>', function()
    if vim.tbl_contains({ '?', '/' }, fn.getcmdtype()) then
      return '<C-t>'
    end

    if start_of_line() and not first_line() then
      local char_under_cur = get_char(0)
      if char_under_cur ~= '' then
        return '<Del><Up><End>' .. char_under_cur .. '<Down><Home>'
      else
        local prev_line = api.nvim_buf_get_lines(0, line('.') - 2,
          line('.') - 1, false)[1]
        local char_end_of_prev_line = prev_line:sub(-1)
        if char_end_of_prev_line ~= '' then
          return '<Up><End><BS><Down><Home>' .. char_end_of_prev_line
        end
        return ''
      end
    end
    if end_of_line() then
      local char_before = get_char(-1)
      if get_char(-2) ~= '' or fn.mode() == 'c' then
        return '<BS><Left>' .. char_before .. '<End>'
      else
        return '<BS><Up><End>' .. char_before .. '<Down><End>'
      end
    end
    if mid_of_line() then
      return '<BS><Right>' .. get_char(-1)
    end
  end, { expr = true })

  map('!', '<C-u>', function()
    if not start_of_line() then
      local current_line = fn.mode() == 'c' and fn.getcmdline()
        or api.nvim_get_current_line()
      local pos = fn.mode() == 'c' and fn.getcmdpos() or col('.')
      fn.setreg('-', current_line:sub(1, pos - 1))
    end
    return '<C-u>'
  end, { expr = true })

  map('!', '<C-y>', '<C-r>-')

  map('!', '<M-b>', '<S-Left>')
  map('c', '<M-f>', '<S-Right>')
  map('i', '<M-f>', '<C-o>e<Right>')
  map('!', '<M-d>', '<C-o>dw')
  map('!', '<C-BS>', '<C-w>')
  map('!', '<M-BS>', '<C-w>')
  map('!', '<M-Del>', '<C-w>')
end

return M
