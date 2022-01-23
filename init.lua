-- vim.cmd('source lua/init/general.vim')
pcall(require, 'init/plugins')
require 'init.keymappings'
require 'init/general'
require 'init/autocmd'
