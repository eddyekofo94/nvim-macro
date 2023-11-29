require('headlines').setup({
  markdown = {
    headline_highlights = {},
    codeblock_highlight = 'CodeBlock',
    fat_headlines = false,
    fat_headline_upper_string = '',
    fat_headline_lower_string = '',
  },
})

---Set default highlight groups for headlines.nvim
---@return nil
local function set_default_hlgroups()
  local hl = require('utils.hl')
  local bg = hl.cblend(
    '#ffffff',
    hl.get(0, {
      name = 'CursorLine',
    }).bg,
    0.05
  ).dec
  hl.set(0, 'CodeBlock', { bg = bg })
  hl.set(0, 'markdownCode', { bg = bg, fg = 'markdownCode' })
  hl.set(0, '@text.literal.markdown_inline', {
    bg = bg,
    fg = '@text.literal.markdown_inline',
  })
end
set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('HeadlinesSetDefaultHlGroups', {}),
  desc = 'Set default highlight groups for headlines.nvim.',
  callback = set_default_hlgroups,
})
