local M = {}
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local conds = require('snippets.utils.conds')

M.cpp_snippets = {
  s({
    trig = '^#include fmt',
    regTrig = true,
    snippetType = 'autosnippet',
    condition = -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
    show_condition = -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
  }, {
    t({ '#define FMT_HEADER_ONLY', '' }),
    t({ '#include <fmt/core.h>', '' }),
    t({ '#include <fmt/format.h>', '' }),
  }),
}

return M
