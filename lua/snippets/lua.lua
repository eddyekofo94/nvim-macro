local M = {}
local un = require('snippets.utils.nodes')
local uf = require('snippets.utils.funcs')
local us = require('snippets.utils.snips')
local ls = require('luasnip')
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node

M.syntax = {
  us.msc({
    { trig = 'lv' },
    { trig = 'lc' },
    { trig = 'l=' },
  }, {
    t('local '),
    i(1, 'var'),
    t(' = '),
    i(0, 'value'),
  }),
  us.msc({
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
  us.msc({
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
  us.msc({
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
  us.sc({ trig = 'if' }, {
    t('if '),
    i(1, 'condition'),
    t({ ' then', '' }),
    un.idnt(1),
    i(2),
    t({ '', 'end' }),
  }),
  us.msc({
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
  us.msc({
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
  us.sc({
    trig = 'else',
    snippetType = 'autosnippet',
  }, {
    t({ 'else', '' }),
    un.idnt(1),
  }),
  us.sc({
    trig = '^(%s*)elif',
    snippetType = 'autosnippet',
    regTrig = true,
  }, {
    un.idnt(function(_, snip)
      return uf.get_indent_depth(snip.captures[1]) - 1
    end),
    t({ 'elseif ' }),
    i(1, 'condition'),
    t({ ' then', '' }),
    un.idnt(function(_, snip)
      return uf.get_indent_depth(snip.captures[1])
    end),
  }),
  us.sc({
    trig = 'else%s*if',
    regTrig = true,
    snippetType = 'autosnippet',
  }, {
    t('elseif '),
    i(1, 'condition'),
    t({ ' then', '' }),
    un.idnt(1),
  }),
  us.sc({ trig = 'for' }, {
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
  us.msc({
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
  us.msc({
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
  us.msc({
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
  us.msc({
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
  us.sc({ trig = 'do' }, {
    t({ 'do', '' }),
    un.idnt(1),
    i(1),
    t({ '', 'end' }),
  }),
  us.msc({
    { trig = 'r' },
    { trig = 'rt' },
    { trig = 'ret' },
  }, {
    t('return '),
  }),
  us.msc({
    { trig = 'p' },
  }, {
    t('print('),
    i(1),
    t(')'),
  }),
  us.msc({
    { trig = 'rq' },
    { trig = 'req' },
  }, {
    t('require('),
    i(1),
    t(')'),
  }),
  us.sc({ trig = 'ps' }, {
    t('pairs('),
    i(1),
    t(')'),
  }),
  us.msc({
    { trig = 'ip' },
    { trig = 'ips' },
  }, {
    t('ipairs('),
    i(1),
    t(')'),
  }),
}

M.nvim = {
  us.sc(
    { trig = 'spec' },
    un.fmtad(
      [[
        {
        <idnt><q><author>/<plugin_name><q>,<cont>
        <idnt>config = function()
        <idnt><idnt>require(<q>configs.<plugin_base_name><q>)
        <idnt>end,
        },<fin>
      ]],
      {
        plugin_name = i(1),
        plugin_base_name = f(function(text, _, _)
          return text[1][1]:gsub('%..*', '')
        end, { 1 }),
        author = i(2),
        cont = i(3),
        fin = i(0),
        idnt = t('\t'),
        q = un.qt(),
      }
    )
  ),
  us.msc({
    { trig = 'nt' },
    { trig = 'not' },
    { trig = 'noti' },
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
  us.sc({ trig = 'api' }, {
    t('vim.api.nvim_'),
  }),
  us.sc({ trig = 'vfn' }, {
    t('vim.fn.'),
  }),
  us.msc({
    { trig = 'in' },
    { trig = 'ins' },
    { trig = 'insp' },
  }, {
    t('vim.inspect('),
    i(1),
    t(')'),
  }),
  us.msc({
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
  us.msc(
    {
      { trig = 'pck' },
      { trig = 'pcheck' },
    },
    un.fmtad('print(<q><v>: <q> .. vim.inspect(<v>)<e>)', {
      q = un.qt(),
      v = i(1),
      e = i(2),
    })
  ),
  us.msc(
    {
      common = { priority = 999 },
      { trig = 'ck' },
      { trig = 'check' },
    },
    un.fmtad('<q><v>: <q> .. vim.inspect(<v>)', {
      q = un.qt(),
      v = i(1),
    })
  ),
  us.msc(
    {
      common = { regTrig = true },
      { trig = '(%S?)(%s*)%.%.%s*ck' },
      { trig = '(%S?)(%s*)%.%.%s*check' },
    },
    un.fmtad('<spc>.. <q>, <v>: <q> .. vim.inspect(<v>)', {
      spc = f(function(_, snip, _)
        return snip.captures[1] == '' and snip.captures[2]
          or snip.captures[1] .. ' '
      end, {}, {}),
      q = un.qt(),
      v = i(1),
    })
  ),
}

return M
