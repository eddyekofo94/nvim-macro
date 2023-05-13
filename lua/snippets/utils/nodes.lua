local ls = require('luasnip')
local f = ls.function_node
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node

---Returns a string for indentation at the given depth
---@param depth number
---@return string
local function get_indent_str(depth)
  local sts
  if vim.bo.sts > 0 then
    sts = vim.bo.sts
  elseif vim.bo.sw > 0 then
    sts = vim.bo.sw
  else
    sts = vim.bo.ts
  end

  if vim.bo.expandtab then
    return string.rep(' ', sts * depth)
  else
    local n_tab = math.floor(sts * depth / vim.bo.ts)
    local indent_str = string.rep('\t', n_tab)
    indent_str = indent_str .. string.rep(' ', sts * depth % vim.bo.ts)
    return indent_str
  end
end

---Returns a function node that returns a string for indentation at the given
---depth
---@param depth number
---@return table node
local function function_indent_node(depth)
  return f(function()
    return get_indent_str(depth)
  end, {}, {})
end

---Returns a dynamic node for suffix snippet
---@param jump_index number
---@param opening string
---@param closing string
---@return table node
local function simple_suffix_dynamic_node(jump_index, opening, closing)
  return d(jump_index or 1, function(_, snip)
    local symbol = snip.captures[1]
    if symbol == nil or not symbol:match('%S') then
      return sn(nil, { t(opening), i(1), t(closing) })
    end
    return sn(nil, { t(opening), t(symbol), t(closing) })
  end)
end

return {
  idnt = function_indent_node,
  sdn = simple_suffix_dynamic_node,
}
