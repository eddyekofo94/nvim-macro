vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  group = vim.api.nvim_create_augroup('SmartExpandtabSetup', {}),
  callback = function()
    require('plugin.expandtab').setup()
    return true
  end,
})
