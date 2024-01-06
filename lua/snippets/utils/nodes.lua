local ls = require('luasnip')
local f = ls.function_node
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta

local M = {}

---Returns a function node that returns a string for indentation at the given
---depth
---@param depth number|fun(...): number
---@param argnode_references number|table?
---@param node_opts table?
---@return table node
function M.idnt(depth, argnode_references, node_opts)
  return f(function(...)
    return require('snippets.utils.funcs').get_indent_str(depth, ...)
  end, argnode_references, node_opts)
end

---Returns function node that returns a quotation mark based on the number of
---double quotes and single quotes in the first 128 lines current buffer
---@param argnode_references number|table?
---@param opts table?
---@return table node
function M.qt(argnode_references, opts)
  return f(function()
    return require('snippets.utils.funcs').get_quotation_type()
  end, argnode_references, opts)
end

---Returns a dynamic node for suffix snippet
---@param jump_index number
---@param opening string
---@param closing string
---@return table node
function M.sdn(jump_index, opening, closing)
  return d(jump_index or 1, function(_, snip)
    local symbol = snip.captures[1]
    if symbol == nil or not symbol:match('%S') then
      return sn(nil, { t(opening), i(1), t(closing) })
    end
    return sn(nil, { t(opening), t(symbol), t(closing) })
  end)
end

---A format node with repeat_duplicates set to true
M.fmtd = ls.extend_decorator.apply(fmt, {
  repeat_duplicates = true,
})

---A format node with <> as placeholders and repeat_duplicates set to true
M.fmtad = ls.extend_decorator.apply(fmta, {
  repeat_duplicates = true,
})

return M
