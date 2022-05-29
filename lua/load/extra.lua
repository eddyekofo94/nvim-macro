if (vim.fn.argc() >= 2)
    and packer_plugins['barbar.nvim']
    and packer_plugins['barbar.nvim'].loaded == false
then
  vim.cmd [[packadd barbar.nvim]]
  require('plugin-configs.barbar')
end
