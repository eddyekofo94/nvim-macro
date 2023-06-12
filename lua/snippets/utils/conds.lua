local lsconds = require('luasnip.extras.conditions')

---@class snip_conds_t
---@field make_condition function
local M = setmetatable({
  _ = {},
}, {
  __index = function(self, k)
    return self._[k] and lsconds.make_condition(self._[k]) or lsconds[k]
  end,
  __newindex = function(self, k, v)
    self._[k] = v
  end,
})

---Returns whether the cursor is in a math zone
---@return boolean
function M.in_mathzone()
  return vim.g.loaded_vimtex == 1
    and vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

---Returns whether the cursor is in a code block
---@return boolean
function M.in_codeblock()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return require('utils.funcs').ft.markdown.in_code_block(
    vim.api.nvim_buf_get_lines(0, 0, cursor[1], false)
  )
end

---Returns whether current cursor is in a comment
---@return boolean
function M.in_comment()
  local buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  if not vim.treesitter.highlighter.active[buf] then
    return false
  end
  local node = vim.treesitter.get_node({
    bufnr = buf,
    pos = { cursor[1] - 1, cursor[2] - 1 },
  })
  if not node then
    return false
  end
  return node:type():match('comment') ~= nil
end

---Returns whether the cursor is in a normal zone
---@return boolean
function M.in_normalzone()
  return not M.in_mathzone() and not M.in_codeblock() and not M.in_comment()
end

return M
