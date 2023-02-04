local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.setup({
  check_ts = true,
  ignored_next_char = [=[[%w%%%'%[%"%.%`]]=],
  fast_wrap = {
    map = '<C-c>',
    chars = { '{', '[', '(', '"', "'", '`' },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    offset = 0, -- Offset from pattern match
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment'
  }
})

npairs.add_rules({
  -- Add spaces between parenthesis
  Rule(' ', ' ')
      :with_pair(function(opts)
        local pair_single_char = opts.line:sub(opts.col - 1, opts.col)
        local pair_double_char = opts.line:sub(opts.col - 2, opts.col + 1)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair_single_char) or
            vim.tbl_contains({ '/**/' }, pair_double_char)
      end)
      :with_del(function(opts)
        return vim.fn.match(opts.line:sub(1, opts.col):reverse(),
          [[\s\((\|[\|{\|\*\/\)]]) == 0
      end),

  Rule('/*', '*/', { 'c', 'cpp' }),
  Rule('$', '$', { 'markdown', 'tex' })                              : with_pair(cond.none()),
  Rule('\\(', '\\)', { 'tex' })                                      : with_pair(cond.not_before_text('\\)')),
  Rule('\\[', '\\]', { 'tex' })                                      : with_pair(cond.not_before_text('\\]')),
  Rule('\\{', '\\}', { 'markdown', 'tex' })                          : with_pair(cond.not_before_text('\\}')),
  Rule('\\left(', '\\right)', { 'markdown', 'tex' })                 : with_pair(cond.not_before_text('\\right)')),
  Rule('\\left[', '\\right]', { 'markdown', 'tex' })                 : with_pair(cond.not_before_text('\\right]')),
  Rule('\\left{', '\\right}', { 'markdown', 'tex' })                 : with_pair(cond.not_before_text('\\right}')),
  Rule('\\left<', '\\right>', { 'markdown', 'tex' })                 : with_pair(cond.not_before_text('\\right>')),
  Rule('\\left\\lfloor ', ' \\right\\rfloor', { 'markdown', 'tex' }) : with_pair(cond.not_before_text('\\right\\rfloor)')),
  Rule('\\left\\lceil ', ' \\right\\rceil', { 'markdown', 'tex' })   : with_pair(cond.not_before_text('\\right\\rceil)')),
  Rule('\\left\\vert ', ' \\right\\vert', { 'markdown', 'tex' })     : with_pair(cond.not_before_text('\\right\\vert')),
  Rule('\\left\\lVert ', ' \\right\\lVert', { 'markdown', 'tex' })   : with_pair(cond.not_before_text('\\right\\lVert')),
  Rule('*', '*', { 'markdown' })                                     : with_pair(cond.none()),
})
