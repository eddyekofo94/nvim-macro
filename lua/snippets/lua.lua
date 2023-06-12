local M = {}
local un = require('snippets.utils.nodes')
local uf = require('snippets.utils.funcs')
local conds = require('snippets.utils.conds')
local ls = require('luasnip')
local s = ls.snippet
local ms = ls.multi_snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmta = require('luasnip.extras.fmt').fmta

M.syntax = {
  snip = uf.add_attr({ condition = -conds.in_comment }, {
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
      i(2, 'args'),
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
      i(1, 'func'),
      t('('),
      i(2, 'args'),
      t({ ')', '' }),
      un.idnt(1),
      i(3),
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
      i(3, 'args'),
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
      { trig = 'ifei' },
      { trig = 'ifeli' },
      { trig = 'ifelif' },
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
      trig = '^(%s*)el',
      regTrig = true,
    }, {
      un.idnt(function(_, parent)
        return uf.get_indent_depth(parent.captures[1]) - 1
      end),
      t({ 'else', '' }),
      un.idnt(function(_, parent)
        return uf.get_indent_depth(parent.captures[1])
      end),
      i(0),
    }),
    ms({
      common = { regTrig = true },
      { trig = '^(%s*)ei' },
      { trig = '^(%s*)eli' },
      { trig = '^(%s*)elif' },
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
      i(0),
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
      i(0),
    }),
    s({ trig = 'forr' }, {
      t('for '),
      i(1, 'i'),
      t(' = '),
      i(2, 'start'),
      t(', '),
      i(3, 'stop'),
      t({ ' do', '' }),
      un.idnt(1),
      i(4),
      t({ '', 'end' }),
    }),
    s({ trig = 'for' }, {
      t('for '),
      i(1, 'elements'),
      t(' in '),
      i(2, 'iterable'),
      t({ ' do', '' }),
      un.idnt(1),
      i(3),
      t({ '', 'end' }),
    }),
    s({ trig = 'forp' }, {
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
    s({ trig = 'forip' }, {
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
      { trig = 'whl' },
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
    s({ trig = 'pr' }, {
      t('print('),
      i(1),
      t(')'),
    }),
    s({ trig = 're' }, {
      t('require('),
      i(1),
      t(')'),
    }),
  }),
}

M.nvim = {
  snip = uf.add_attr({ condition = -conds.in_comment }, {
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
      { trig = 'prin' },
      { trig = 'prins' },
      { trig = 'prinsp' },
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
