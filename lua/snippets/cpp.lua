local M = {}
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node

M.cpp_snippets = {
  s({ trig = '^#include fmt', regTrig = true, snippetType = 'autosnippet' }, {
    t({ '#define FMT_HEADER_ONLY', '' }),
    t({ '#include <fmt/core.h>', '' }),
    t({ '#include <fmt/format.h>', '' }),
  }),
}

return M
