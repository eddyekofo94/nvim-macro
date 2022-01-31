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

-- `PackerSync` on save of `plugins.lua`
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

pcall(require, 'compile/packer_compiled')

local get = require('utils/get')
return require('packer').startup({
  function(use)
    use(get.spec('packer'))             -- Packer manages itself

    -- Appearance
    use(get.spec('nvim-treesitter'))
    use(get.spec('falcon'))             -- Color scheme

    -- Editing
    use(get.spec('nvim-cmp'))
    use(get.spec('vim-easymotion'))     -- Moving around like magic!
    use(get.spec('vsc-vim-easymotion')) -- Easymotion for vscode-neovim
    use(get.spec('vim-surround'))
    use(get.spec('vim-commentary'))

    -- LSP
    use(get.spec('nvim-lsp-installer'))

    -- Navigation
    use(get.spec('alpha-nvim'))         -- Greeting page
    use(get.spec('nvim-tree'))          -- File tree
    use(get.spec('barbar'))             -- Buffer line

    -- Git
    use(get.spec('gitsigns'))

    -- Notes
    use(get.spec('markdown-preview'))

    -- Tools
    use(get.spec('startuptime'))        -- Tools to test startuptime
    use(get.spec('impatient'))          -- Speed up lua `require()`
    use(get.spec('nvim-colorizer'))     -- Show inline RGB colors
  end,

  config = {
    clone_timeout = 300,
    compile_path = fn.stdpath('config') .. '/lua/compile/packer_compiled.lua',
    opt_default = false,
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'double' })
      end,
      working_sym = '',
      error_sym = '',
      done_sym = '',
      removed_sym = '﫧',
      moved_sym = 'ﰲ'
    }
  }
})
