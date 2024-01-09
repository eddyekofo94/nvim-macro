---Record previous cmdline completion types,
---cmdcompltype[1] is the current completion type,
---cmdcompltype[2] is the previous completion type
---@type string[]
local compltype = {}

vim.api.nvim_create_autocmd('CmdlineChanged', {
  desc = 'Record cmd compltype to determine whether to autopair.',
  group = vim.api.nvim_create_augroup('AutopairRecordCmdCompltype', {}),
  callback = function()
    local type = vim.fn.getcmdcompltype()
    if compltype[1] == type then
      return
    end
    compltype[2] = compltype[1]
    compltype[1] = type
  end,
})

require('ultimate-autopair').setup({
  extensions = {
    alpha = { after = true },
    cond = {
      cond = function(f)
        return not f.in_macro()
          -- Disable autopairs when inserting a regex,
          -- e.g. `:s/{pattern}/{string}/[flags]` or
          -- `:g/{pattern}/[cmd]`, etc.
          and (
            not f.in_cmdline()
            or compltype[1] ~= ''
            or compltype[2] ~= 'command'
          )
      end,
    },
  },
  { '\\(', '\\)' },
  { '\\[', '\\]' },
  { '\\{', '\\}' },
  { '<<<', '>>>', ft = { 'cuda' } },
  {
    '/*',
    '*/',
    ft = { 'c', 'cpp', 'cuda' },
    newline = true,
    space = true,
  },
  -- Paring '$' and '*' are handled by snippets,
  -- only use autopair to delete matched pairs here
  {
    '$',
    '$',
    ft = { 'markdown', 'tex' },
    disable_start = true,
    disable_end = true,
  },
  {
    '*',
    '*',
    ft = { 'markdown' },
    disable_start = true,
    disable_end = true,
  },
  {
    '\\left(',
    '\\right)',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left[',
    '\\right]',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left{',
    '\\right}',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left<',
    '\\right>',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lfloor ',
    ' \\right\\rfloor',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lceil ',
    ' \\right\\rceil',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\vert ',
    ' \\right\\vert',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lVert ',
    ' \\right\\rVert',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\left\\lVert ',
    ' \\right\\rVert',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\begin{bmatrix} ',
    ' \\end{bmatrix}',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
  {
    '\\begin{pmatrix} ',
    ' \\end{pmatrix}',
    newline = true,
    space = true,
    ft = { 'markdown', 'tex' },
  },
})
