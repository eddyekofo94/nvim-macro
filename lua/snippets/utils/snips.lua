local ls = require('luasnip')
local conds = require('snippets.utils.conds')

-- Map snippet attribute string to snippet attribute options
local snip_attr_map = {
  w = { wordTrig = true },
  W = { wordTrig = false },
  r = { regTrig = true },
  R = { regTrig = false },
  h = { hidden = true },
  H = { hidden = false },
  a = { snippetType = 'autosnippet' },
  A = { snippetType = 'snippet' },
  m = {
    condition = conds.in_mathzone,
    show_condition = conds.in_mathzone,
  },
  M = {
    condition = -conds.in_mathzone,
    show_condition = -conds.in_mathzone,
  },
  n = {
    condition = conds.in_normalzone,
    show_condition = conds.in_normalzone,
  },
  N = {
    condition = -conds.in_normalzone,
    show_condition = -conds.in_normalzone,
  },
}

return setmetatable({}, {
  __index = function(self, snip_name)
    local snip_attr_str = snip_name:gsub('^m?s', '')
    local snip_attr = {}
    for i = 1, #snip_attr_str do
      local snip_attr_opts = snip_attr_map[snip_attr_str:sub(i, i)]
      if snip_attr_opts then
        for attr_opt_key, attr_opt_val in pairs(snip_attr_opts) do
          snip_attr[attr_opt_key] = attr_opt_val
        end
      end
    end
    if snip_name:match('^m') then
      self[snip_name] = ls.extend_decorator.apply(ls.multi_snippet, {
        common = snip_attr,
      })
    else
      self[snip_name] = ls.extend_decorator.apply(ls.snippet, snip_attr)
    end
    return self[snip_name]
  end,
})
