local function add_attr(attr, snip_group)
  for _, snip in ipairs(snip_group) do
    for attr_key, attr_val in pairs(attr) do
      snip[attr_key] = attr_val
    end
  end
  return snip_group
end

local function in_mathzone()
  if not packer_plugins['vimtex'] then
    return false
  end
  vim.cmd('packadd vimtex')
  return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local function not_in_mathzone()
  return not in_mathzone()
end

local function get_char_after()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1,
    cursor[1], true)[1]
  return current_line:sub(cursor[2], cursor[2])
end

local function get_indent_str(depth)
  local f = require('luasnip').function_node
  local sts
  if vim.bo.sts > 0 then sts = vim.bo.sts
  elseif vim.bo.sw > 0 then sts = vim.bo.sw
  else sts = vim.bo.ts end

  if vim.bo.expandtab then
    return string.rep(' ', sts * depth)
  else
    local n_tab = math.floor(sts * depth / vim.bo.ts)
    local indent_str = string.rep('\t', n_tab)
    indent_str = indent_str .. string.rep(' ', sts * depth % vim.bo.ts)
    return indent_str
  end
end

local function indent_function_node(depth)
  local f = require('luasnip').function_node
  return f(function() return get_indent_str(depth) end, {}, {})
end

return {
  add_attr = add_attr,
  in_mathzone = in_mathzone,
  not_in_mathzone = not_in_mathzone,
  get_char_after = get_char_after,
  ifn = indent_function_node,
}
