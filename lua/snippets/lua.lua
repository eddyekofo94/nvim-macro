local M = {}
local funcs = require('snippets.utils.funcs')
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

M.snippets = {
  s({ trig = 'spec' }, fmta([[
{
<indent>'<author>/<plugin_name>',<finish>
<indent>config = configs['<plugin_name>'],
},
  ]], {
    plugin_name = i(1),
    author = i(2),
    indent = funcs.ifn(1),
    finish = i(0),
  }, { repeat_duplicates = true })),
  s({ trig = 'config' }, fmta([[
M['<plugin_name>'] = function()
<indent><config>
end
  ]], {
    plugin_name = i(1),
    config = i(0),
    indent = funcs.ifn(1),
  }, { repeat_duplicates = true })),
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
      i(nil, 'TRACE')
    }),
    t(')'),
  }),
}

return M
