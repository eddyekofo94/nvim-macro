local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')
local utils = require('nvim-autopairs.utils')

-- Override the default is_in_quotes function to
-- treat primes differently from quotes
-- Oringal function
local _is_in_quotes = utils.is_in_quotes

---check cursor is inside a quote
---@param line string
---@param pos number  position in line
---@param quote_type nil|string specify a quote
---@return boolean
---@diagnostic disable-next-line: duplicate-set-field
function utils.is_in_quotes(line, pos, quote_type)
  local text_fts = {
    '',
    'tex',
    'help',
    'text',
    'markdown',
    'gitcommit',
  }
  if not vim.tbl_contains(text_fts, vim.bo.ft) then
    return _is_in_quotes(line, pos, quote_type)
  end

  local cur_idx = 0
  local result = false
  local last_char = quote_type or ''

  while cur_idx < string.len(line) and cur_idx < pos do
    cur_idx = cur_idx + 1
    local char = line:sub(cur_idx, cur_idx)
    local char_before = line:sub(cur_idx - 1, cur_idx - 1)
    if result == true and char == last_char and char_before ~= '\\' then
      result = false
      last_char = quote_type or ''
    elseif
      result == false
      and utils.is_quote(char)
      and (not quote_type or char == quote_type)
      and not (char == "'" and char_before:match('%w'))
    then
      last_char = quote_type or char
      result = true
    end
  end
  return result
end

npairs.setup({
  check_ts = true,
  enable_check_bracket_line = false,
  ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
  fast_wrap = {
    map = '<M-c>',
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
