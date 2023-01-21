local M = {}

M['nvim-surround'] = function()
  require('nvim-surround').setup()
end

M['Comment.nvim'] = function()
  require('Comment').setup()
end

M['nvim-autopairs'] = function()
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
      highlight_grey='Comment'
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
    -- markdown/tex math env braces
    Rule('\\{', '\\}', { 'markdown', 'tex' }),
    -- markdown italic/bold, pairing is taken care by snippets
    Rule('*', '*', { 'markdown' })
      :with_pair(function() return false end),
  })
end

M['vim-easy-align'] = function()
  vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(EasyAlign)', { noremap = false })
  vim.keymap.set({ 'n', 'x' }, 'gA', '<Plug>(LiveEasyAlign)', { noremap = false })
  vim.g.easy_align_delimiters = {
    ['\\'] = {
      pattern = [[\\\+]],
    },
    ['/'] = {
      pattern = [[//\+\|/\*\|\*/]],
      delimiter_align = 'c',
      ignore_groups = '!Comment',
    },
  }
end

return M
