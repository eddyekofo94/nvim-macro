local M = {}

M['nvim-surround'] = function()
  require('nvim-surround').setup()
end

M['Comment.nvim'] = function()
  require('Comment').setup({
    ignore = '^$',
  })
end

M['nvim-autopairs'] = function()
  local npairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')

  npairs.setup({
    check_ts = true,
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
  })
end

M['nvim-colorizer'] = function()
  require('colorizer').setup()
end

return M
