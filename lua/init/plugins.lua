local function manage_plugins(config)
  config = vim.tbl_deep_extend('force', {
    root = vim.fn.stdpath('data') .. '/lazy',
    ui = {
      border = 'shadow',
      size = {
        width = 0.7,
        height = 0.74,
      },
    },
    checker = {
      enabled = false,
    },
    change_detection = {
      notify = false,
    },
    install = {
      colorscheme = { 'nvim-falcon' },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
          'health',
        },
      },
    },
  }, config)

  -- Install lazy if not already installed
  local url = 'https://github.com/folke/lazy.nvim.git'
  local lazy_path = config.root .. '/lazy.nvim'
  vim.opt.rtp:prepend(lazy_path)
  vim.opt.pp:prepend(lazy_path)
  if not vim.loop.fs_stat(lazy_path) then
    vim.notify('Installing lazy.nvim...', vim.log.levels.INFO)
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', url, lazy_path })
    vim.notify('lazy.nvim cloned to ' .. lazy_path, vim.log.levels.INFO)
  end

  local lazy_view_config = require('lazy.view.config')
  lazy_view_config.keys.details = '<Tab>'

  require('lazy').setup(config)
end

if vim.g.vscode then
  manage_plugins({
    spec = {
      { import = 'modules.base' },
      { import = 'modules.treesitter' },
      { import = 'modules.misc' },
    }
  })
else
  manage_plugins({
    spec = {
      { import = 'modules' },
    },
  })
end

-- a handy abbreviation
vim.cmd('cnoreabbrev lz Lazy')
