local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

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
  -- autopair c block comment
  Rule('/*', '*/', { 'c', 'cpp' }),
  -- markdown/tex math, pairing is taken care by snippets
  Rule('$', '$', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\(', '\\)', { 'tex' })
      :with_pair(function() return false end),
  Rule('\\[', '\\]', { 'tex' })
      :with_pair(function() return false end),
  -- markdown/tex math left right env
  Rule('\\left(', '\\right)', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left[', '\\right]', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left{', '\\right}', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left<', '\\right>', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left\\lfloor ', ' \\right\\rfloor', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left\\lceil ', ' \\right\\rceil', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left\\vert ', ' \\right\\vert', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  Rule('\\left\\lVert ', ' \\right\\lVert', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  -- markdown/tex aligned text
  Rule('&= ', ' \\\\', { 'markdown', 'tex' })
      :with_pair(function() return false end),
  -- markdown/tex math env braces
  Rule('\\{', '\\}', { 'markdown', 'tex' }),
  -- markdown italic/bold, pairing is taken care by snippets
  Rule('*', '*', { 'markdown' })
      :with_pair(function() return false end),
})
