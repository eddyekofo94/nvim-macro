local M = {}
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

local function in_mathzone()
  vim.cmd('packadd vimtex')
  return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local function not_in_mathzone()
  return not in_mathzone()
end

local function add_cond(cond, snip_group)
  for _, snip in ipairs(snip_group) do
    snip.condition = cond
  end
  return snip_group
end

M.math_snippets = {
  snip = add_cond(in_mathzone, {
    s({ trig = '(%S*)(%d)', regTrig = true }, {
      d(1, function(_, snip)
        local symbol = snip.captures[1]
        local subscript = snip.captures[2]
        if vim.fn.match(symbol, [[\(\a\|}\|]\|)\)$]]) == -1 then
          return sn(nil, { t(symbol), t(subscript) })
        end
        return sn(nil, { t(symbol), t '_', t(subscript) })
      end),
      i(0),
    }),
    s({ trig = '(\\?%w*)//', regTrig = true }, {
      d(1, function(_, snip)
        local numerator = snip.captures[1]
        if numerator == nil or not numerator:match('%S') then
          return sn(nil, { t '\\frac{', i(1), t '}{', i(2), t '}' })
        end
        return sn(nil, { t '\\frac{', t(numerator), t '}{', i(1), t '}' })
      end),
      i(0),
    }),
    s({ trig = 'inf' }, { t '\\infty', i(0) }),
    s({ trig = 'deg' }, { t '\\degree', i(0) }),
    s({ trig = 'ang' }, { t '\\angle ', i(0) }),
    s({ trig = 'mcal' }, { t '\\mathcal{', i(1), t '}', i(0) }),
    s({ trig = 'msrc' }, { t '\\mathsrc{', i(1), t '}', i(0) }),
    s({ trig = 'mbb' }, { t '\\mathbb{', i(1), t '}', i(0) }),
    s({ trig = 'mrm' }, { t '\\mathrm{', i(1), t '}', i(0) }),
    s({ trig = 'xx' }, { t '\\times ', i(0) }),
    s({ trig = '**' }, { t '\\cdot ', i(0) }),
    s({ trig = 'o*' }, { t '\\circledast ', i(0) }),
    s({ trig = 'dd' }, { t '\\mathrm{d}', i(0) }),

    s({ trig = '!=' }, { t '\\neq ', i(0) }),
    s({ trig = '==' }, { t '&= ', i(0) }),
    s({ trig = '&= =' }, { t '\\equiv ', i(0) }),
    s({ trig = '>=' }, { t '\\ge ', i(0) }),
    s({ trig = '<=' }, { t '\\le ', i(0) }),
    s({ trig = '<->', priority = 999 }, { t '\\leftrightarrow ', i(0) }),
    s({ trig = '\\le >', priority = 999 }, { t '\\Leftrightarrow ', i(0) }),
    s({ trig = '<--', priority = 999 }, { t '\\leftarrow ', i(0) }),
    s({ trig = '\\le =', priority = 999 }, { t '\\Leftarrow ', i(0) }),
    s({ trig = '-->', priority = 999 }, { t '\\rightarrow ', i(0) }),
    s({ trig = '&= >', priority = 999 }, { t '\\Rightarrow ', i(0) }),
    s({ trig = 'x<->' }, { t '\\xleftrightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x\\le >' }, { t '\\xLeftrightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x<--' }, { t '\\xleftarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x\\le =' }, { t '\\xLeftarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x-->' }, { t '\\xrightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = 'x&= >' }, { t '\\xRightarrow[', i(1), t ']{', i(2), t '} ', i(0) }),
    s({ trig = '->', priority = 998 }, { t '\\to ', i(0) }),
    s({ trig = '=>', priority = 998 }, { t '\\implies ', i(0) }),
    s({ trig = '|>' }, { t '\\mapsto ', i(0) }),
    s({ trig = '=>' }, t '\\implies ', i(0)),

    s({ trig = '_' }, { t '_{', i(1), t '}', i(0) }),
    s({ trig = '^' }, { t '^{', i(1), t '}', i(0) }),
    s({ trig = '>>' }, { t '\\gg ', i(0) }),
    s({ trig = '<<' }, { t '\\ll ', i(0) }),
    s({ trig = '...' }, { t '\\ldots' }),
    s({ trig = '~~' }, { t '\\sim ' }),
    s({ trig = '~=' }, { t '\\approx ' }),
    s({ trig = '//' }, { t '\\frac{', i(1), t '}{', i(2), t '}' }),
    s({ trig = '||' }, { t '\\mid ', i(0) }),
    s({ trig = '/.' }, { t '\\sqrt{', i(1), t '}', i(0) }),
    s({ trig = '\\\\\\' }, { t '\\setminus ', i(0) }),
    s({ trig = '%%' }, { t '\\%', i(0) }),

    s({ trig = 'compl' }, { t '^{C} ', i(0) }),
    s({ trig = 'set' }, { t '\\{', i(1), t '\\}', i(0) }),
    s({ trig = 'tt' }, { t '\\text{', i(1), t '}', i(0) }),
    s({ trig = 'cc' }, { t '\\subset ', i(0) }),
    s({ trig = 'notin' }, { t '\\notin ', i(0) }),
    s({ trig = 'in ' }, { t '\\in ', i(0) }),
    s({ trig = 'uu' }, { t '\\cup ', i(0) }),
    s({ trig = 'nn' }, { t '\\cap ', i(0) }),
    s({ trig = 'NN' }, { t '\\N ', i(0) }),
    s({ trig = 'bigv' }, { t '\\big\\rvert_{', i(1), t '}' }),
    s({ trig = 'forall' }, { t '\\forall ', i(0) }),
    s({ trig = 'any' }, { t '\\forall ', i(0) }),
    s({ trig = 'exist' }, { t '\\exist ', i(0) }),
    s({ trig = 'transp' }, { t '^{\\intercal}', i(0) }),
    s({ trig = 'inv' }, { t '^{-1}', i(0) }),

    s({ trig = 'sin', priority = 999 }, { t '\\mathrm{sin}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'cos', priority = 999 }, { t '\\mathrm{cos}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'tan', priority = 999 }, { t '\\mathrm{tan}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'asin' }, { t '\\mathrm{arcsin}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'acos' }, { t '\\mathrm{arccos}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'atan' }, { t '\\mathrm{arctan}\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'sc' }, { t '\\mathrm{sinc}\\left(', i(1), t '\\right)', i(0) }),

    s({ trig = 'abs' }, { t '\\left\\vert ', i(1), t '\\right\\vert', i(0) }),
    s({ trig = 'lrv' }, { t '\\left\\vert ', i(1), t '\\right\\vert', i(0) }),
    s({ trig = 'lrb' }, { t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'lr)' }, { t '\\left(', i(1), t '\\right)', i(0) }),
    s({ trig = 'lr]' }, { t '\\left[', i(1), t '\\right]', i(0) }),
    s({ trig = 'lrB' }, { t '\\left{', i(1), t '\\right}', i(0) }),
    s({ trig = 'lr}' }, { t '\\left{', i(1), t '\\right}', i(0) }),
    s({ trig = 'lr>' }, { t '\\left<', i(1), t '\\right>', i(0) }),

    s({ trig = 'floor' }, { t '\\left\\lfloor ', i(1), t ' \\right\\rfloor', i(0) }),
    s({ trig = 'ceil' }, { t '\\left\\lceil ', i(1), t ' \\right\\rceil', i(0) }),
    s({ trig = 'bmat' }, { t { '\\begin{bmatrix}', '' }, i(1), t { '', '\\end{bmatrix}' } }, i(0)),
    s({ trig = 'pmat' }, { t {'\\begin{pmatrix}', '' }, i(1), t { '', '\\end{pmatrix}' } }, i(0)),
    s({ trig = 'aln' }, { t { '\\begin{align*}', '' }, i(0), t { '', '\\end{align*}' } }),
    s({ trig = 'eqt' }, { t { '\\begin{equation*}', '' }, i(0), t { '', '\\end{equation*}' } }),
    s({ trig = 'cas' }, { t { '\\begin{cases}', '' }, i(1), t { '', '\\end{cases}' } }, i(0)),
    s({ trig = 'part' }, { t { '\\frac{\\partial ' }, i(1), t { '}{\\partial ' }, i(2), t { '}' }, i(0) }),
    s({ trig = 'diff' }, { t '\\frac{\\mathrm{d}', i(1), t '}{\\mathrm{d}', i(2), t '} ', i(0) }),
    s({ trig = 'int', priority = 998 }, { t '\\int_{', i(1), t '}^{', i(2), t '} ', i(0) }),
    s({ trig = 'iint', priority = 999 }, { t '\\iint_{', i(1), t '}^{', i(2), t '} ', i(0) }),
    s({ trig = 'iiint' }, { t '\\iiint_{', i(1), t '}^{', i(2), t '} ', i(0) }),
    s({ trig = 'sum' }, { t '\\sum_{', i(1), t '}^{', i(2), t '} ', i(0) }),

    s({ trig = 'alpha' }, { t '\\alpha', i(0) }),
    s({ trig = 'beta' }, { t '\\beta', i(0) }),
    s({ trig = 'gamma' }, { t '\\gamma', i(0) }),
    s({ trig = 'delta' }, { t '\\delta', i(0) }),
    s({ trig = 'zeta' }, { t '\\zeta', i(0) }),
    s({ trig = 'mu' }, { t '\\mu', i(0) }),
    s({ trig = 'rho' }, { t '\\rho', i(0) }),
    s({ trig = 'sigma' }, { t '\\sigma', i(0) }),
    s({ trig = 'eta', priority = 998 }, { t '\\eta', i(0) }),
    s({ trig = 'eps', priority = 999 }, { t '\\epsilon', i(0) }),
    s({ trig = 'veps' }, { t '\\varepsilon', i(0) }),
    s({ trig = 'theta', priority = 999 }, { t '\\theta', i(0) }),
    s({ trig = 'vtheta' }, { t '\\vartheta', i(0) }),
    s({ trig = 'iota' }, { t '\\iota', i(0) }),
    s({ trig = 'kappa' }, { t '\\kappa', i(0) }),
    s({ trig = 'lambda' }, { t '\\lambda', i(0) }),
    s({ trig = 'nu' }, { t '\\nu', i(0) }),
    s({ trig = 'pi' }, { t '\\pi', i(0) }),
    s({ trig = 'tau' }, { t '\\tau', i(0) }),
    s({ trig = 'ups' }, { t '\\upsilon', i(0) }),
    s({ trig = 'phi' }, { t '\\phi', i(0) }),
    s({ trig = 'psi' }, { t '\\psi', i(0) }),
    s({ trig = 'omg' }, { t '\\omega', i(0) }),
    s({ trig = 'Alpha' }, { t '\\Alpha', i(0) }),
    s({ trig = 'Beta' }, { t '\\Beta', i(0) }),
    s({ trig = 'Gamma' }, { t '\\Gamma', i(0) }),
    s({ trig = 'Delta' }, { t '\\Delta', i(0) }),
    s({ trig = 'Zeta' }, { t '\\Zeta', i(0) }),
    s({ trig = 'Mu' }, { t '\\Mu', i(0) }),
    s({ trig = 'Rho' }, { t '\\Rho', i(0) }),
    s({ trig = 'Sigma' }, { t '\\Sigma', i(0) }),
    s({ trig = 'Eta' }, { t '\\Eta', i(0) }),
    s({ trig = 'Eps' }, { t '\\Epsilon', i(0) }),
    s({ trig = 'Theta' }, { t '\\Theta', i(0) }),
    s({ trig = 'Iota' }, { t '\\Iota', i(0) }),
    s({ trig = 'Kappa' }, { t '\\Kappa', i(0) }),
    s({ trig = 'Lambda' }, { t '\\Lambda', i(0) }),
    s({ trig = 'Nu' }, { t '\\Nu', i(0) }),
    s({ trig = 'Pi' }, { t '\\Pi', i(0) }),
    s({ trig = 'Tau' }, { t '\\Tau', i(0) }),
    s({ trig = 'Ups' }, { t '\\Upsilon', i(0) }),
    s({ trig = 'Phi' }, { t '\\Phi', i(0) }),
    s({ trig = 'Psi' }, { t '\\Psi', i(0) }),
    s({ trig = 'Omg' }, { t '\\Omega', i(0) }),
  }),
  opts = { wordTrig = false, type = 'autosnippets' },
}

M.md_normal = {
  snip = add_cond(not_in_mathzone, {
    s({ trig = '^# ', regTrig = true, snippetType = 'autosnippet' }, {
      t '# ',
      dl(1, l.TM_FILENAME:gsub('^%d*_', ''):gsub('_', ' '):gsub('%..*', ''), {}),
      i(0),
    }),

    s('package', {
      t { '---', '' },
      t { 'header-includes:', '' },
      t { '    - \\usepackage{gensymb}', '' },
      t { '    - \\usepackage{amsmath}', '' },
      t { '    - \\usepackage{amssymb}', '' },
      t { '    - \\usepackage{mathtools}', '' },
      t { '---', '' },
    }),
  }),
}

return M
