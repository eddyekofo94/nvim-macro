local funcs = require('snippets.utils.funcs')
local ifn = funcs.ifn
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

local M = require('snippets.shared.math')

M.env_standalone = {
  snip = funcs.add_attr({ condition = funcs.not_in_mathzone }, {
    s({ trig = 'env' }, fmta([[
\begin{<env>}
<indent><text>
\end{<env>}
    ]] , {
      indent = ifn(1),
      env = i(1),
      text = i(0),
    }, { repeat_duplicates = true })),
    s({ trig = 'cs' }, {
      t { '\\begin{equation}', '\\begin{cases}', '' },
      ifn(1),
      i(1),
      t { '', '\\end{cases}', '\\end{equation}' }
    }),
    s({ trig = 'aln' }, fmta([[
\begin{<env>}
<indent><text>
\end{<env>}
    ]], {
      env = c(1, { i(nil, 'align*'), i(nil, 'align') }),
      indent = ifn(1),
      text = i(0),
    }, { repeat_duplicates = true })),
    s({ trig = 'eqt' }, fmta([[
\begin{<env>}
<indent><text>
\end{<env>}
    ]], {
      env = c(1, { i(nil, 'equation*'), i(nil, 'equation') }),
      indent = ifn(1),
      text = i(0),
    }, { repeat_duplicates = true })),
  }),
}

M.style = {
  snip = funcs.add_attr({ condition = funcs.not_in_mathzone }, {
    s({ trig = 'em' } , { t '\\emph{', i(1), t '}' }),
    s({ trig = 'bf' }, { t '\\textbf{', i(1), t '}' }),
    s({ trig = 'ul' }, { t '\\underline{', i(1), t '}' }),
  })
}

M.style_auto = {
  snip = funcs.add_attr({ condition = funcs.not_in_mathzone }, {
    s({ trig = '^[^\\]- ', regTrig = true }, { t '\\item' }),
    s({ trig = '\\item(%w)', regTrig = true }, d(1, function(_, snip)
        return sn(nil, { t('\\item{' .. snip.captures[1]), i(1), t '}' })
      end))
    }),
  opts = { type = 'autosnippets' },
}

return M
