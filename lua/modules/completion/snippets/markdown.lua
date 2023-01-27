local M = {}
local funcs = require('modules.completion.snippets.utils.funcs')
local fn = vim.fn
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

M.math = require('modules.completion.snippets.share.math')

local function add_attr(attr, snip_group)
  for _, snip in ipairs(snip_group) do
    for attr_key, attr_val in pairs(attr) do
      snip[attr_key] = attr_val
    end
  end
  return snip_group
end

M.format = {
  snip = funcs.add_attr({ condition = funcs.not_in_mathzone }, {
    s({ trig = '^# ', regTrig = true, snippetType = 'autosnippet' }, {
      t '# ',
      dl(1, l.TM_FILENAME:gsub('^%d*_', ''):gsub('_', ' '):gsub('%..*', ''), {}),
      i(0),
    }),
    s('package', {
      t { '---', '' },
      t { 'header-includes:', '' },
      funcs.ifn(1), t { '- \\usepackage{gensymb}', '' },
      funcs.ifn(1), t { '- \\usepackage{amsmath}', '' },
      funcs.ifn(1), t { '- \\usepackage{amssymb}', '' },
      funcs.ifn(1), t { '- \\usepackage{mathtools}', '' },
      t { '---', '' },
    }),
  }),
}

M.markers = {
  snip = funcs.add_attr({ condition = funcs.not_in_mathzone }, {
    s({ trig = 'm' } , { t '$', i(1), t '$' }),
    s({ trig = 'M' } , { t { '$$', '' }, i(1), t { '', '$$' } }),
    s({ trig = 'e' } , { t '*', i(1), t '*', i(0) }),
    s({ trig = 'b' }, { t '**', i(1), t '**', i(0) }),
    s({ trig = 'B' }, { t '***', i(1), t '***', i(0) }),
  }),
}


return M
