local M = {}
local utils = require('utils')

---Check if the current line is a markdown code block
---@param lines_or_lnum string[]|integer|nil default to current line number
function M.in_codeblock(lines_or_lnum, buf)
  buf = buf or 0
  lines_or_lnum = lines_or_lnum or vim.api.nvim_win_get_cursor(0)[1]
  local lines = type(lines_or_lnum) == 'number'
      and vim.api.nvim_buf_get_lines(buf, 0, lines_or_lnum - 1, false)
    or lines_or_lnum --[=[@as string[]]=]
  local result = false
  for _, line in ipairs(lines) do
    if line:match('^```') then
      result = not result
    end
  end
  return result
end

---Returns whether the cursor is in a math zone
---@return boolean
function M.in_mathzone()
  return utils.funcs.ft.tex.in_mathzone()
end

---Returns whether the cursor is in normal zone
---(not in math zone or code block)
---@return boolean
function M.in_normalzone()
  return not M.in_mathzone() and not M.in_codeblock()
end

return M
