local argc = vim.fn.argc()
if (argc == 0)
    and packer_plugins['alpha-nvim']
    and not packer_plugins['alpha-nvim'].loaded
then
  vim.cmd [[packadd alpha-nvim]]
  require('plugin-configs.alpha-nvim')
elseif (argc >= 2)
    and packer_plugins['barbar.nvim']
    and not packer_plugins['barbar.nvim'].loaded
then
  vim.cmd [[packadd barbar.nvim]]
  require('plugin-configs.barbar')
end
