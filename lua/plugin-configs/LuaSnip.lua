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
local types = require 'luasnip.util.types'
local conds = require('luasnip.extras.expand_conditions')

ls.setup({
  history = true,
  region_check_events = 'CursorMoved',
  delete_check_events = 'TextChangedI',
  updateevents = 'TextChanged,TextChangedI,InsertLeave',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
  ext_opts = {
    [ls_types.choiceNode] = {
      active = {
        virt_text = { { ' ', 'IconColor1' } },
      },
    },
    [ls_types.insertNode] = {
      active = {
        virt_text = { { '●', 'IconColor1' } },
      },
    },
  },
  parser_nested_assembler = function(_, snippet)
    local select = function(snip, no_move)
      snip.parent:enter_node(snip.indx)
      for _, node in ipairs(snip.nodes) do
        node:set_mark_rgrav(true, true)
      end
      if not no_move then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
        local pos_begin, pos_end = snip.mark:pos_begin_end()
        util.normal_move_on(pos_begin)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('v', true, false, true), 'n', true)
        util.normal_move_before(pos_end)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('o<C-G>', true, false, true), 'n', true)
      end
    end

    function snippet:jump_into(dir, no_move)
      if self.active then
        if dir == 1 then
          self:input_leave()
          return self.next:jump_into(dir, no_move)
        else
          select(self, no_move)
          return self
        end
      else
        self:input_enter()
        if dir == 1 then
          select(self, no_move)
          return self
        else
          return self.inner_last:jump_into(dir, no_move)
        end
      end
    end

    function snippet:jump_from(dir, no_move)
      if dir == 1 then
        return self.inner_first:jump_into(dir, no_move)
      else
        self:input_leave()
        return self.prev:jump_into(dir, no_move)
      end
    end

    return snippet
  end,
})

local function md_in_mathzone()
  return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local function add_snippets_in_math_zone(langs, snips, opts)
  for _, v in pairs(snips) do
    v.condition = md_in_mathzone
  end
  for _, lang in ipairs(langs) do
    ls.add_snippets(lang, snips, opts)
  end
end

local symbols = {
  s({ trig = '([^%s]*)//', regTrig = true }, {
    d(1, function(_, snip)
      local selected = snip.env.TM_SELECTED_TEXT[1]
      if selected then
        return sn(nil, { t '\\frac{', t(selected), t '}{', i(1), t '}' })
      end
      p(snip.captures[1])
      if snip.captures[1] == nil
          or not snip.captures[1]:match('%S') then
        return sn(nil, { t '\\frac{', i(1), t '}{', i(2), t '}' })
      end
      return sn(nil, { t '\\frac{', t(snip.captures[1]), t '}{', i(1), t '}' })
    end),
    i(0),
  }),
  s('!=', { t '\\neq ', i(0) }),
  s('==', { t '&= ', i(0) }),
  s('ooo', { t '\\infty', i(0) }),
  s('>=', { t '\\ge', i(0) }),
  s('<=', { t '\\le', i(0) }),
  s('mcal', { t '\\mathcal{', i(1), t '} ', i(0) }),
  s('msrc', { t '\\mathsrc{', i(1), t '} ', i(0) }),
  s('lll', { t '\\ell', i(0) }),
  s({ trig = '\\?nabla', regTrig = true }, { t '\\nabla', i(0) }),
  s('xx', { t '\\times', i(0) }),
  s('**', { t '\\cdot', i(0) }),
  s('<->', { t '\\leftrightarrow', i(0) }),
  s('dint', { t '\\int_{', i(1), t '}^{', i(2), t '} ', i(0) }),
  s('->', { t '\\to', i(0) }),
  s('|>', { t '\\mapsto', i(0) }),
  s('=>', t '\\implies', i(0)),
  s('compl', { t '^{C} ', i(0) }),
  s('\\\\\\', { t '\\setminus ', i(0) }),
  s('set', { t '\\{', i(1), t '\\} ', i(0) }),
  s('tt', { t '\\text{', i(1), t '}', i(0) }),
  s('cc', { t '\\subset', i(0) }),
  s('notin', { t '\\not\\in ', i(0) }),
  s('inn', { t '\\in ', i(0) }),
  s('uu', { t '\\cup ', i(0) }),
  s('nn', { t '\\cap ', i(0) }),
  s('NN', { t '\\N ', i(0) }),
  s('//', { t '\\frac{', i(1), t '}{', i(2), t '}' }),
  s('||', { t '\\mid ', i(0) }),
  s('%%', { t '\\%', i(0) }),
  s('forall', { t '\\forall ', i(0) }),
  s('/.', { t '\\sqrt{', i(1), t '}', i(0) }),
  s({ trig = 'transp', wordTrig = false }, { t '^{\\intercal}', i(0) }),
  s({ trig = 'inv', wordTrig = false }, { t '^{-1}', i(0) }),
  s({ trig = '_', wordTrig = false }, { t '_{', i(1), t '}', i(0) }),
  s({ trig = '^', wordTrig = false }, { t '^{', i(1), t '}', i(0) }),
  s({ trig = '>>', wordTrig = false }, { t '\\gg ', i(0) }),
  s({ trig = '<<', wordTrig = false }, { t '\\ll ', i(0) }),
  s({ trig = '...', wordTrig = false }, { t '\\ldots' }),
  s({ trig = '~~', wordTrig = false }, { t '\\sim' }),
  s({ trig = '~=', wordTrig = false }, { t '\\approx' }),
}

for _, v in pairs { 'bar', 'hat', 'vec', 'tilde' } do
  symbols[#symbols + 1] = s(
    { trig = ('\\?%s'):format(v), regTrig = true },
    { t(('\\%s{'):format(v)), i(1), t '}', i(0) }
  )
  symbols[#symbols + 1] = s({ trig = '([^%s]*)' .. v, regTrig = true }, {
    d(1, function(_, snip, _)
      return sn(nil, { t(('\\%s{%s}'):format(v, snip.captures[1])) }, i(0))
    end),
  })
end

local enclosing = {
  s({ trig = 'abs', name = 'Absolute Values' }, { t '\\left\\vert', i(1), t '\\right\\vert', i(0) }),
  s({ trig = 'lrp', name = 'Parenthesis' }, { t '\\left(', i(1), t '\\right)', i(0) }),
  s({ trig = 'lrb', name = 'Brackets' }, { t '\\left[', i(1), t '\\right]', i(0) }),
  s({ trig = 'lrB', name = 'Curly Brackets' }, { t '\\left{', i(1), t '\\right}', i(0) }),
  s({ trig = 'lra', name = 'Angles' }, { t '\\left<', i(1), t '\\right>', i(0) }),
}

local normal = {
  s('ceil', { t '\\left\\lceil ', i(1), t ' \\right\\rceil', i(0) }),
  s('bmat', { t { '\\begin{bmatrix}', '' }, i(1), t { '', '\\end{bmatrix}' }, i(0) }),
  s('pmat', { t {'\\begin{pmatrix}', '' }, i(1), t { '', '\\end{pmatrix}' }, i(0) }),
  s('aln', { t { '\\begin{align}', '' }, i(1), t { '', '\\end{align}' }, i(0) }),
  s('eqt', { t { '\\begin{equation}', '' }, i(1), t { '', '\\end{equation}' }, i(0) }),
  s('cas', { t { '\\begin{cases}', '' }, i(1), t { '', '\\end{cases}' }, i(0) }),
  s('part', { t { '\\frac{\\partial ' }, i(1), t { '}{\\partial ' }, i(2), t { '}' }, i(0) }),
  s('int', { t '\\int_{', i(1), t '}^{', i(2), t '} ', i(0) }),
  s('sum', { t '\\sum_{', i(1), t '}^{', i(2), t '} ', i(0) }),
}

local greek = {
  s({ trig = 'alpha', wordTrig = false }, { t '\\alpha', i(0) }),
  s({ trig = 'beta', wordTrig = false }, { t '\\beta', i(0) }),
  s({ trig = 'gamma', wordTrig = false }, { t '\\gamma', i(0) }),
  s({ trig = 'delta', wordTrig = false }, { t '\\delta', i(0) }),
  s({ trig = 'zeta', wordTrig = false }, { t '\\zeta', i(0) }),
  s({ trig = 'mu', wordTrig = false }, { t '\\mu', i(0) }),
  s({ trig = 'rho', wordTrig = false }, { t '\\rho', i(0) }),
  s({ trig = 'sigma', wordTrig = false }, { t '\\sigma', i(0) }),
  s({ trig = 'eta', wordTrig = false }, { t '\\eta', i(0) }),
  s({ trig = 'eps', wordTrig = false }, { t '\\epsilon', i(0) }),
  s({ trig = 'vareps', wordTrig = false }, { t '\\varepsilon', i(0) }),
  s({ trig = 'theta', wordTrig = false }, { t '\\theta', i(0) }),
  s({ trig = 'vtheta', wordTrig = false }, { t '\\vartheta', i(0) }),
  s({ trig = 'iota', wordTrig = false }, { t '\\iota', i(0) }),
  s({ trig = 'kappa', wordTrig = false }, { t '\\kappa', i(0) }),
  s({ trig = 'lambda', wordTrig = false }, { t '\\lambda', i(0) }),
  s({ trig = 'nu', wordTrig = false }, { t '\\nu', i(0) }),
  s({ trig = 'pi', wordTrig = false }, { t '\\pi', i(0) }),
  s({ trig = 'tau', wordTrig = false }, { t '\\tau', i(0) }),
  s({ trig = 'ups', wordTrig = false }, { t '\\upsilon', i(0) }),
  s({ trig = 'phi', wordTrig = false }, { t '\\phi', i(0) }),
  s({ trig = 'psi', wordTrig = false }, { t '\\psi', i(0) }),
  s({ trig = 'omega', wordTrig = false }, { t '\\omega', i(0) }),
  s({ trig = 'Alpha', wordTrig = false }, { t '\\Alpha', i(0) }),
  s({ trig = 'Beta', wordTrig = false }, { t '\\Beta', i(0) }),
  s({ trig = 'Gamma', wordTrig = false }, { t '\\Gamma', i(0) }),
  s({ trig = 'Delta', wordTrig = false }, { t '\\Delta', i(0) }),
  s({ trig = 'Zeta', wordTrig = false }, { t '\\Zeta', i(0) }),
  s({ trig = 'Mu', wordTrig = false }, { t '\\Mu', i(0) }),
  s({ trig = 'Rho', wordTrig = false }, { t '\\Rho', i(0) }),
  s({ trig = 'Sigma', wordTrig = false }, { t '\\Sigma', i(0) }),
  s({ trig = 'Eta', wordTrig = false }, { t '\\Eta', i(0) }),
  s({ trig = 'Eps', wordTrig = false }, { t '\\Epsilon', i(0) }),
  s({ trig = 'Theta', wordTrig = false }, { t '\\Theta', i(0) }),
  s({ trig = 'Iota', wordTrig = false }, { t '\\Iota', i(0) }),
  s({ trig = 'Kappa', wordTrig = false }, { t '\\Kappa', i(0) }),
  s({ trig = 'Lambda', wordTrig = false }, { t '\\Lambda', i(0) }),
  s({ trig = 'Nu', wordTrig = false }, { t '\\Nu', i(0) }),
  s({ trig = 'Pi', wordTrig = false }, { t '\\Pi', i(0) }),
  s({ trig = 'Tau', wordTrig = false }, { t '\\Tau', i(0) }),
  s({ trig = 'Ups', wordTrig = false }, { t '\\Upsilon', i(0) }),
  s({ trig = 'Phi', wordTrig = false }, { t '\\Phi', i(0) }),
  s({ trig = 'Psi', wordTrig = false }, { t '\\Psi', i(0) }),
  s({ trig = 'Omega', wordTrig = false }, { t '\\Omega', i(0) }),
}

add_snippets_in_math_zone({ 'tex', 'markdown' }, symbols, { type = 'autosnippets' })
add_snippets_in_math_zone({ 'tex', 'markdown' }, enclosing, { type = 'autosnippets' })
add_snippets_in_math_zone({ 'tex', 'markdown' }, normal, {})
add_snippets_in_math_zone({ 'tex', 'markdown' }, greek, { type = 'autosnippets' })
