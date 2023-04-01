local indent_blankline = require('indent_blankline')
local indent_blankline_utils = require('indent_blankline.utils')

-- Fix indent-blankline bug #489
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
vim.api.nvim_create_augroup('IndentBlankLineFix', {})
vim.api.nvim_create_autocmd('WinScrolled', {
  group = 'IndentBlankLineFix',
  callback = function()
    if vim.v.event.all.leftcol ~= 0 then
      indent_blankline.refresh(false)
    end
  end,
})

---Check if indent-blankline is enabled for current buffer
---@return boolean
local function indent_line_is_enabled()
  return indent_blankline_utils.is_indent_blankline_enabled(
    vim.b.indent_blankline_enabled,
    vim.g.indent_blankline_enabled,
    indent_blankline_utils.get_variable('indent_blankline_disable_with_nolist'),
    vim.opt.list:get(),
    vim.bo.filetype,
    indent_blankline_utils.get_variable('indent_blankline_filetype') or {},
    indent_blankline_utils.get_variable('indent_blankline_filetype_exclude'),
    vim.bo.buftype,
    indent_blankline_utils.get_variable('indent_blankline_buftype_exclude')
      or {},
    indent_blankline_utils.get_variable('indent_blankline_bufname_exclude')
      or {},
    vim.fn['bufname']('')
  )
end

---Disable indent-blankline temporarily
local function indent_blankline_temp_disable()
  if indent_line_is_enabled() then
    vim.b.indent_blankline_enabled = false
    vim.b.__indent_blankline_active = false
    vim.b.__indent_blankline_temp_disabled = true
    vim.api.nvim_buf_clear_namespace(
      0,
      vim.g.indent_blankline_namespace,
      1,
      -1
    )
  end
end

---Recover indent-blankline from temporary disabled state
local function indent_blankline_recover()
  if vim.b.__indent_blankline_temp_disabled then
    vim.b.__indent_blankline_temp_disabled = false
    vim.b.indent_blankline_enabled = true
    indent_blankline.refresh(false)
  end
end

-- Disable indent-blankline when in visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
  group = 'IndentBlankLineFix',
  pattern = { '[vV\x16]*:*', '*:[vV\x16]*' },
  callback = function()
    if vim.fn.match(vim.v.event.new_mode, '[vV\x16]') ~= -1 then
      indent_blankline_temp_disable()
    else
      indent_blankline_recover()
    end
  end,
})

-- Disable indent-blankline in diff mode
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'diff',
  group = 'IndentBlankLineFix',
  callback = function()
    if vim.wo.diff then
      indent_blankline_temp_disable()
    else
      indent_blankline_recover()
    end
  end,
})

indent_blankline.setup({
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
  use_treesitter = false,
  max_indent_increase = 1,
  filetype_exclude = {
    '',
    'man',
    'help',
    'markdown',
    'checkhealth',
  },
})
