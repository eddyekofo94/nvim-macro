local uf = require('snippets.utils.funcs')
local un = require('snippets.utils.nodes')
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local l = require('luasnip.extras').lambda
local dl = require('luasnip.extras').dynamic_lambda

local M = require('snippets.shared.math')

local function in_normal_zone()
  local cursor_lnum = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, cursor_lnum, false)
  return not uf.in_mathzone()
    and not require('utils.funcs').ft.markdown.in_code_block(lines)
end

M.format = {
  snip = uf.add_attr({ condition = in_normal_zone }, {
    s({ trig = '^# ', regTrig = true, snippetType = 'autosnippet' }, {
      t('# '),
      dl(
        1,
        l.TM_FILENAME:gsub('^%d*_', ''):gsub('_', ' '):gsub('%..*', ''),
        {}
      ),
      i(0),
    }),
    s('package', {
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
  snip = uf.add_attr({ condition = in_normal_zone }, {
    s({
      trig = '*',
      condition = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        return line:sub(col + 1, col + 1) == '*' and uf.not_in_mathzone()
      end,
    }, { t('*'), i(0), t('*') }),
    s(
      { trig = '**', priority = 999, condition = uf.not_in_mathzone },
      { t('*'), i(0), t('*') }
    ),
  }),
  opts = { type = 'autosnippets' },
}

M.titles = {
  snip = uf.add_attr({ condition = in_normal_zone }, {
    s({ trig = 'h1' }, { t('# '), i(0) }),
    s({ trig = 'h2' }, { t('## '), i(0) }),
    s({ trig = 'h3' }, { t('### '), i(0) }),
    s({ trig = 'h4' }, { t('#### '), i(0) }),
    s({ trig = 'h5' }, { t('##### '), i(0) }),
    s({ trig = 'h6' }, { t('###### '), i(0) }),
  }),
}

M.theorems = {
  snip = uf.add_attr({ condition = in_normal_zone }, {
    s({ trig = 'theo' }, { t('***'), i(1, 'Theorem'), t('***') }),
    s({ trig = 'def' }, { t('***'), i(1, 'Definition'), t('***') }),
    s({ trig = 'pro' }, { t('***'), i(1, 'Proof'), t('***') }),
    s({ trig = 'lem' }, { t('***'), i(1, 'Lemma'), t('***') }),
  }),
}

return M
