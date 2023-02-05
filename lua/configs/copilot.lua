vim.defer_fn(function()
  if vim.g.loaded_coplilot then
    return
  end
  vim.g.loaded_coplilot = true
  require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })
end, 100)
