vim.defer_fn(function()
  if vim.g.loaded_coplilot then
    return
  end
  vim.g.loaded_coplilot = true
  require('copilot').setup({
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = '<C-j>',
      },
    },
    filetypes = {
      markdown = true,
      help = true,
    },
  })
end, 100)
