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
  hl.set(0, 'CodeBlock', { bg = 'NormalFloat' })
  hl.set(0, 'markdownCode', { bg = 'NormalFloat', fg = 'markdownCode' })
  hl.set(
    0,
    '@text.literal.markdown_inline',
    { bg = 'NormalFloat', fg = '@text.literal.markdown_inline' }
  )
end
set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('HeadlinesSetDefaultHlGroups', {}),
  desc = 'Set default highlight groups for headlines.nvim.',
  callback = set_default_hlgroups,
})
