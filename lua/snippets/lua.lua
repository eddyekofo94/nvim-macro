local M = {}
local un = require('snippets.utils.nodes')
local uf = require('snippets.utils.funcs')
local conds = require('snippets.utils.conds')
local ls = require('luasnip')
local s = ls.snippet
local ms = ls.multi_snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmta = require('luasnip.extras.fmt').fmta

M.syntax = {
  snip = uf.add_attr({
    condition = -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
    show_condition = -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
  }, {
    ms({
      { trig = 'lv' },
      { trig = 'lc' },
      { trig = 'l=' },
    }, {
      t('local '),
      i(1, 'var'),
      t(' = '),
      i(0, 'value'),
    }),
    ms({
      { trig = 'lf' },
      { trig = 'lfn' },
      { trig = 'lfun' },
      { trig = 'lfunc' },
      { trig = 'lfunction' },
    }, {
      t('local function '),
      i(1, 'func'),
      t('('),
      i(2),
      t({ ')', '' }),
      un.idnt(1),
      i(3),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'fn' },
      { trig = 'fun' },
      { trig = 'func' },
      { trig = 'function' },
    }, {
      t('function('),
      i(1),
      t({ ')', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'me' },
      { trig = 'method' },
    }, {
      t('function '),
      i(1, 'class'),
      t(':'),
      i(2, 'method'),
      t('('),
      i(3),
      t({ ')', '' }),
      un.idnt(1),
      i(4),
      t({ '', 'end' }),
    }),
    s({ trig = 'if' }, {
      t('if '),
      i(1, 'condition'),
      t({ ' then', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'ife' },
      { trig = 'ifel' },
      { trig = 'ifelse' },
    }, {
      t('if '),
      i(1, 'condition'),
      t({ ' then', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'else', '' }),
      un.idnt(1),
      i(3),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'ifelif' },
      { trig = 'ifelseif' },
    }, {
      t('if '),
      i(1, 'condition_1'),
      t({ ' then', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'elseif ' }),
      i(3, 'condition_2'),
      t({ '', '' }),
      un.idnt(1),
      i(4),
      t({ '', 'end' }),
    }),
    s({
      trig = 'else',
      snippetType = 'autosnippet',
    }, {
      t({ 'else', '' }),
      un.idnt(1),
    }),
    s({
      trig = '^(%s*)elif',
      snippetType = 'autosnippet',
      regTrig = true,
    }, {
      un.idnt(function(_, parent)
        return uf.get_indent_depth(parent.captures[1]) - 1
      end),
      t({ 'elseif ' }),
      i(1, 'condition'),
      t({ ' then', '' }),
      un.idnt(function(_, parent)
        return uf.get_indent_depth(parent.captures[1])
      end),
    }),
    s({
      trig = 'else%s*if',
      regTrig = true,
      snippetType = 'autosnippet',
    }, {
      t('elseif '),
      i(1, 'condition'),
      t({ ' then', '' }),
      un.idnt(1),
    }),
    s({ trig = 'for' }, {
      t('for '),
      c(1, {
        sn(nil, {
          i(1, '_'),
          t(', '),
          i(2, 'v'),
          t(' in ipairs('),
          i(3, 'tbl'),
          t(')'),
        }),
        sn(nil, {
          i(1, 'k'),
          t(', '),
          i(2, 'v'),
          t(' in pairs('),
          i(3, 'tbl'),
          t(')'),
        }),
        sn(nil, {
          i(1, 'elements'),
          t(' in '),
          i(2, 'iterable'),
        }),
        sn(nil, {
          t('i'),
          t(' = '),
          i(1, 'start'),
          t(', '),
          i(2, 'stop'),
          t(', '),
          i(3, 'step'),
        }),
        sn(nil, {
          t('i'),
          t(' = '),
          i(1, 'start'),
          t(', '),
          i(2, 'stop'),
        }),
      }),
      t({ ' do', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'fr' },
      { trig = 'frange' },
      { trig = 'forr' },
      { trig = 'forange' },
      { trig = 'forrange' },
    }, {
      t('for '),
      c(1, {
        sn(nil, {
          i(1, 'i'),
          t(' = '),
          i(2, 'start'),
          t(', '),
          i(3, 'stop'),
        }),
        sn(nil, {
          i(1, 'i'),
          t(' = '),
          i(2, 'start'),
          t(', '),
          i(3, 'stop'),
          t(', '),
          i(4, 'step'),
        }),
      }),
      t({ ' do', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'fp' },
      { trig = 'fps' },
      { trig = 'fpairs' },
      { trig = 'forp' },
      { trig = 'forps' },
      { trig = 'forpairs' },
    }, {
      t('for '),
      i(1, '_'),
      t(', '),
      i(2, 'v'),
      t(' in pairs('),
      i(3, 'tbl'),
      t({ ') do', '' }),
      un.idnt(1),
      i(4),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'fip' },
      { trig = 'fips' },
      { trig = 'fipairs' },
      { trig = 'forip' },
      { trig = 'forips' },
      { trig = 'foripairs' },
    }, {
      t('for '),
      i(1, '_'),
      t(', '),
      i(2, 'v'),
      t(' in ipairs('),
      i(3, 'tbl'),
      t({ ') do', '' }),
      un.idnt(1),
      i(4),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'wh' },
      { trig = 'while' },
    }, {
      t('while '),
      i(1, 'condition'),
      t({ ' do', '' }),
      un.idnt(1),
      i(2),
      t({ '', 'end' }),
    }),
    s({ trig = 'do' }, {
      t({ 'do', '' }),
      un.idnt(1),
      i(1),
      t({ '', 'end' }),
    }),
    ms({
      { trig = 'p' },
    }, {
      t('print('),
      i(1),
      t(')'),
    }),
    s({ trig = 'rq' }, {
      t('require('),
      i(1),
      t(')'),
    }),
    s({ trig = 'ps' }, {
      t('pairs('),
      i(1),
      t(')'),
    }),
    ms({
      { trig = 'ip' },
      { trig = 'ips' },
    }, {
      t('ipairs('),
      i(1),
      t(')'),
    }),
  }),
}

M.nvim = {
  snip = uf.add_attr({
    condition = -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
    show_condition = -conds.in_tsnode('comment') * -conds.in_tsnode('string'),
  }, {
    s(
      { trig = 'spec' },
      fmta(
        [[
{
<indent>'<author>/<plugin_name>',<finish>
<indent>config = function()
<indent><indent>require('configs.<plugin_base_name>')
<indent>end,
},
  ]],
        {
          plugin_name = i(1),
          plugin_base_name = f(function(text, _, _)
            return text[1][1]:gsub('%..*', '')
          end, { 1 }),
          author = i(2),
          indent = un.idnt(1),
          finish = i(0),
        },
        { repeat_duplicates = true }
      )
    ),
    ms({
      { trig = 'not' },
      { trig = 'notify' },
    }, {
      t('vim.notify('),
      i(1),
      t(', vim.log.levels.'),
      c(2, {
        i(nil, 'DEBUG'),
        i(nil, 'WARN'),
        i(nil, 'ERROR'),
        i(nil, 'INFO'),
        i(nil, 'OFF'),
        i(nil, 'TRACE'),
      }),
      t(')'),
    }),
    s({ trig = 'api' }, {
      t('vim.api.nvim_'),
    }),
    s({ trig = 'vfn' }, {
      t('vim.fn.'),
    }),
    ms({
      { trig = 'in' },
      { trig = 'ins' },
      { trig = 'insp' },
    }, {
      t('vim.inspect('),
      i(1),
      t(')'),
    }),
    ms({
      { trig = 'pin' },
      { trig = 'pins' },
      { trig = 'pinsp' },
    }, {
      t('print(vim.inspect('),
      i(1),
      t(')'),
      i(2),
      t(')'),
    }),
  }),
}

return M
