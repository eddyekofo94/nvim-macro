vim.api.nvim_create_autocmd({ 'CmdlineEnter', 'InsertEnter' }, {
  callback = function ()
    require('plugin.readline').init()
  end
})
