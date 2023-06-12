local uf = require('snippets.utils.funcs')
local un = require('snippets.utils.nodes')
local conds = require('snippets.utils.conds')
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmta = require('luasnip.extras.fmt').fmta

local M = require('snippets.shared.math')

M.env_standalone = {
  snip = uf.add_attr({ condition = -conds.in_mathzone }, {
    s(
      { trig = 'env' },
      fmta(
        [[
\begin{<env>}
<indent><text>
\end{<env>}
    ]],
        {
          indent = un.idnt(1),
          env = i(1),
          text = i(0),
        },
        { repeat_duplicates = true }
      )
    ),
    s({ trig = 'cs' }, {
      t({ '\\begin{equation}', '\\begin{cases}', '' }),
      un.idnt(1),
      i(1),
      t({ '', '\\end{cases}', '\\end{equation}' }),
    }),
    s(
      { trig = 'aln' },
      fmta(
        [[
\begin{<env>}
<indent><text>
\end{<env>}
    ]],
        {
          env = c(1, { i(nil, 'align*'), i(nil, 'align') }),
          indent = un.idnt(1),
          text = i(0),
        },
        { repeat_duplicates = true }
      )
    ),
    s(
      { trig = 'eqt' },
      fmta(
        [[
\begin{<env>}
<indent><text>
\end{<env>}
    ]],
        {
          env = c(1, { i(nil, 'equation*'), i(nil, 'equation') }),
          indent = un.idnt(1),
          text = i(0),
        },
        { repeat_duplicates = true }
      )
    ),
  }),
}

M.style = {
  snip = uf.add_attr({ condition = -conds.in_mathzone }, {
    s({ trig = 'em' }, { t('\\emph{'), i(1), t('}') }),
    s({ trig = 'bf' }, { t('\\textbf{'), i(1), t('}') }),
    s({ trig = 'ul' }, { t('\\underline{'), i(1), t('}') }),
  }),
}

M.style_auto = {
  snip = uf.add_attr({ condition = -conds.in_mathzone }, {
    s(
      { trig = '^(%s*)- ', regTrig = true },
      f(function(_, parent, _)
        return parent.captures[1] .. '\\item'
      end)
    ),
    s(
      { trig = '\\item(%w)', regTrig = true },
      d(1, function(_, snip)
        return sn(nil, { t('\\item{' .. snip.captures[1]), i(1), t('}') })
      end)
    ),
  }),
  opts = { type = 'autosnippets' },
}

return M
