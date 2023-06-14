local M = {}
local ls = require('luasnip')
local conds = require('snippets.utils.conds')
local s = ls.snippet
local ms = ls.multi_snippet

-- Auto snippets
M.sa = ls.extend_decorator.apply(s, {
  snippetType = 'autosnippet',
})

-- Math auto snippets, automatically expands in math zone
M.sam = ls.extend_decorator.apply(M.sa, {
  condition = conds.in_mathzone,
  show_condition = conds.in_mathzone,
})

-- Math auto snippets with regex trigger
M.samr = ls.extend_decorator.apply(M.sam, {
  regTrig = true,
})

-- Math operator auto snippets, wordTrig = false
M.samo = ls.extend_decorator.apply(M.sam, {
  wordTrig = false,
})

-- Math operator auto snippets with regex trigger
M.samor = ls.extend_decorator.apply(M.samo, {
  regTrig = true,
})

-- Snippets that does not expand in mathzone
M.sM = ls.extend_decorator.apply(s, {
  condition = -conds.in_mathzone,
  show_condition = -conds.in_mathzone,
})

-- Normal zone snippets
M.sn = ls.extend_decorator.apply(s, {
  condition = conds.in_normalzone,
  show_condition = conds.in_normalzone,
})

-- Snippets that does not expand in string or comments ('code' snippets)
M.sc = ls.extend_decorator.apply(s, {
  condition = -conds.ts_active
    + -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
  show_condition = -conds.ts_active
    + -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
})

-- Multi snippets that does not expand in string or comments ('code' snippets)
M.msc = ls.extend_decorator.apply(ms, {
  common = {
    condition = -conds.ts_active
      + -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
    show_condition = -conds.ts_active
      + -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
  },
})

return M
