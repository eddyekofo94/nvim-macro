local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')
local ts_conds = require('nvim-autopairs.ts-conds')

npairs.setup({
  check_ts = true,
  map_c_h = true,
  map_c_w = true,
  disable_in_macro = true,
  enable_check_bracket_line = true,
  ignored_next_char = [=[[%w%%%'%[%"%.%`]]=],
  fast_wrap = {
    map = '<M-c>',
    chars = { '{', '[', '(', '"', "'", '`' },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    offset = 0, -- Offset from pattern match
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment',
  },
})

-- stylua: ignore start
npairs.add_rules({
  -- Add spaces between parenthesis
  Rule(' ', ' ')
    :with_pair(function(opts)
      local pair_single_char = opts.line:sub(opts.col - 1, opts.col)
      local pair_double_char = opts.line:sub(opts.col - 2, opts.col + 1)
      return vim.tbl_contains({ '()', '[]', '{}' }, pair_single_char)
        or vim.tbl_contains({ '/**/' }, pair_double_char)
    end)
    :with_del(function(opts)
      return vim.fn.match(opts.line:sub(1, opts.col):reverse(),
        [[\s\((\|[\|{\|\*\/\)]]) == 0
    end),

  Rule('/*', '*/', { 'c', 'cpp' }),
  Rule('$', '$', { 'markdown', 'tex' })     :with_pair(cond.none()),
  Rule('*', '*', { 'markdown' })            :with_pair(cond.none()),
  Rule('\\(', '\\)', { 'tex' })             :with_pair(cond.not_before_text('\\)')),
  Rule('\\(', '\\)')                        :with_pair(ts_conds.is_ts_node('string')),
  Rule('\\[', '\\]', { 'tex' })             :with_pair(cond.not_before_text('\\]')),
  Rule('\\{', '\\}', { 'tex', 'markdown' }) :with_pair(cond.not_before_text('\\}')),
})
-- stylua: ignore end
