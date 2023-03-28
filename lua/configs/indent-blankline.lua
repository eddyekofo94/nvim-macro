vim.opt.listchars = {
  tab        = '→ ',
  extends    = '…',
  precedes   = '…',
  nbsp       = '⌴',
  trail      = '·',
}

-- Fix indent-blankline bug #489
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
vim.api.nvim_create_augroup('IndentBlankLineFix', {})
vim.api.nvim_create_autocmd('WinScrolled', {
  group = 'IndentBlankLineFix',
  callback = function()
    if vim.v.event.all.leftcol ~= 0 then
      vim.cmd('silent! IndentBlanklineRefresh')
    end
  end,
})

-- Disable indent-blankline when in visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
  group = 'IndentBlankLineFix',
  pattern = { '[vV\x16]*:*', '*:[vV\x16]*' },
  callback = function()
    if vim.fn.match(vim.v.event.new_mode, '[vV\x16]') ~= -1 then
      vim.cmd('silent! IndentBlanklineDisable')
    else
      vim.cmd('silent! IndentBlanklineEnable')
    end
  end,
})

-- Disable indent-blankline in diff mode
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'diff',
  group = 'IndentBlankLineFix',
  callback = function()
    if vim.wo.diff then
      vim.cmd('silent! IndentBlanklineDisable')
    else
      vim.cmd('silent! IndentBlanklineEnable')
    end
  end,
})

require('indent_blankline').setup({
  char = '',
  char_highlight_list = {
    'IndentBlanklineIndent1',
    'IndentBlanklineIndent2',
  },
  space_char_highlight_list = {
    'IndentBlanklineIndent1',
    'IndentBlanklineIndent2',
  },
  show_trailing_blankline_indent = true,
  indent_blankline_use_treesitter = false,
})
