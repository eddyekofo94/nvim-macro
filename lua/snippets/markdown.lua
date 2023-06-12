local uf = require('snippets.utils.funcs')
local un = require('snippets.utils.nodes')
local conds = require('snippets.utils.conds')
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local l = require('luasnip.extras').lambda
local dl = require('luasnip.extras').dynamic_lambda

local M = require('snippets.shared.math')

M.format = {
  snip = uf.add_attr({
    condition = conds.in_normalzone,
    show_condition = conds.in_normalzone,
  }, {
    s({
      trig = '^# ',
      regTrig = true,
      snippetType = 'autosnippet',
    }, {
      t('# '),
      dl(
        1,
        l.TM_FILENAME:gsub('^%d*_', ''):gsub('_', ' '):gsub('%..*', ''),
        {}
      ),
      i(0),
    }),
    s('pkgs', {
      t({ '---', '' }),
      t({ 'header-includes:', '' }),
      un.idnt(1),
      t({ '- \\usepackage{gensymb}', '' }),
      un.idnt(1),
      t({ '- \\usepackage{amsmath}', '' }),
      un.idnt(1),
      t({ '- \\usepackage{amssymb}', '' }),
      un.idnt(1),
      t({ '- \\usepackage{mathtools}', '' }),
      t({ '---', '' }),
    }),
  }),
}

M.markers = {
  snip = uf.add_attr({
    condition = conds.in_normalzone,
    show_condition = conds.in_normalzone,
  }, {
    s(
      { trig = '**', condition = conds.in_normalzone },
      { t('*'), i(0), t('*') }
    ),
  }),
  opts = { type = 'autosnippets' },
}

M.titles = {
  snip = uf.add_attr({ condition = conds.in_normalzone }, {
    s({ trig = 'h1' }, { t('# '), i(0) }),
    s({ trig = 'h2' }, { t('## '), i(0) }),
    s({ trig = 'h3' }, { t('### '), i(0) }),
    s({ trig = 'h4' }, { t('#### '), i(0) }),
    s({ trig = 'h5' }, { t('##### '), i(0) }),
    s({ trig = 'h6' }, { t('###### '), i(0) }),
  }),
}

M.theorems = {
  snip = uf.add_attr({ condition = conds.in_normalzone }, {
    s({ trig = 'theo' }, { t('***'), i(1, 'Theorem'), t('***') }),
    s({ trig = 'def' }, { t('***'), i(1, 'Definition'), t('***') }),
    s({ trig = 'pro' }, { t('***'), i(1, 'Proof'), t('***') }),
    s({ trig = 'lem' }, { t('***'), i(1, 'Lemma'), t('***') }),
  }),
}

return M
