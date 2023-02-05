require('copilot_cmp').setup({
  formatters = {
    label = function(item) return item.text:gsub('^%s*', '') end,
    insert_text = require('copilot_cmp.format').remove_existing
  },
})
