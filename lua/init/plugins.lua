-- Bootstrap packer.nvim if not installed
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local execute = vim.cmd
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system ({
      'git', 'clone', '--depth', '1', packer_url, install_path
    })
    print 'Installing packer.nvim and reopen Neovim...'
    execute 'packadd packer.nvim'
end

local get = require('utils/get')

return require('packer').startup({
  function(use)
      use(get.spec('packer'))   -- Packer manages itself

      -- Appearance
      use(get.spec('nvim-treesitter'))

      -- Tools
      use(get.spec('startuptime'))
  end,

  config = {
    clone_timeout = 300,
    opt_default = false,
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end
    }
  }
})
