---Add attributes to a snippet group
---@param attr table
---@param snip_group table
---@return table
local function add_attr(attr, snip_group)
  for _, snip in ipairs(snip_group) do
    for attr_key, attr_val in pairs(attr) do
      snip[attr_key] = attr_val
    end
  end
  return snip_group
end

---Returns whether the cursor is in a math zone
---@return boolean
local function in_mathzone()
  return vim.g.loaded_vimtex == 1
    and vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

---Returns whether the cursor is not in a math zone
---@return boolean
local function not_in_mathzone()
  return not in_mathzone()
end

---Returns the character after the cursor
---@return string
local function get_char_after()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line =
    vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  return current_line:sub(cursor[2], cursor[2])
end

return {
  add_attr = add_attr,
  in_mathzone = in_mathzone,
  not_in_mathzone = not_in_mathzone,
  get_char_after = get_char_after,
}
