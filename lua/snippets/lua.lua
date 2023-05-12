local M = {}
local un = require('snippets.utils.nodes')
local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmta = require('luasnip.extras.fmt').fmta

M.snippets = {
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
  s({ trig = 'notify' }, {
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
}

return M
