local M = {}
local us = require('snippets.utils.snips')
local ls = require('luasnip')
local t = ls.text_node

M.cpp_snippets = {
  us.sn({
    trig = '^#include fmt',
    regTrig = true,
    snippetType = 'autosnippet',
  }, {
    t({ '#define FMT_HEADER_ONLY', '' }),
    t({ '#include <fmt/core.h>', '' }),
    t({ '#include <fmt/format.h>', '' }),
  }),
}

return M
