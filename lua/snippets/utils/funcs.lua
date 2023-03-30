local M = {}
local fn = vim.fn
local api = vim.api
local ls = require('luasnip')
local ls_types = require('luasnip.util.types')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require('luasnip.extras').lambda
local rep = require('luasnip.extras').rep
local p = require('luasnip.extras').partial
local m = require('luasnip.extras').match
local n = require('luasnip.extras').nonempty
local dl = require('luasnip.extras').dynamic_lambda
local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta
local types = require('luasnip.util.types')
local conds = require('luasnip.extras.expand_conditions')

local function add_attr(attr, snip_group)
  for _, snip in ipairs(snip_group) do
    for attr_key, attr_val in pairs(attr) do
      snip[attr_key] = attr_val
    end
  end
  return snip_group
end

local function in_mathzone()
  return vim.g.loaded_vimtex == 1
    and vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
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
  return f(function() return get_indent_str(depth) end, {}, {})
end

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
  add_attr = add_attr,
  in_mathzone = in_mathzone,
  not_in_mathzone = not_in_mathzone,
  get_char_after = get_char_after,
  ifn = indent_function_node,
  sdn = simple_suffix_dynamic_node,
}
