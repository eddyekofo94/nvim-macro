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

M.env = {
  snip = funcs.add_attr({ condition = funcs.not_in_mathzone }, {
    s({ trig = 'env' }, fmta([[
\begin{<env>}
<text>
\end{<env>}
    ]] , {
      env = i(1, 'align*'),
      text = i(2),
    }, { repeat_duplicates = true })),
    s({ trig = 'm' } , { t '$', i(1), t '$' }),
    s({ trig = 'M' } , { t { '\\[', '' }, i(1), t { '', '\\]' } }),
    s({ trig = 'e' } , { t '\\emph{', i(1), t '}' }),
    s({ trig = 'b' }, { t '\\textbf{', i(1), t '}' }),
    s({ trig = 'B' }, { t '\\textbf{\\textit{', i(1), t '}}' }),
    s({ trig = 'u' }, { t '\\underline{', i(1), t '}' }),
  })
}

return M
