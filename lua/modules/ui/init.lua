local M = {}
local configs = require('modules.ui.configs')

M['nvim-web-devicons'] = {
  'kyazdani42/nvim-web-devicons',
  module = 'nvim-web-devicons',
  config = configs['nvim-web-devicons'],
}

M['barbar.nvim'] = {
  'romgrk/barbar.nvim',
  cond = function()
    vim.api.nvim_create_autocmd('BufAdd', {
      pattern = '*',
      callback = function()
        if not vim.g.loaded_barbar then
          vim.g.loaded_barbar = true
          vim.cmd('packadd barbar.nvim')
          require('modules.ui.configs')['barbar.nvim']()
        end
      end
    })
    return vim.fn.argc() > 0
  end,
  requries = 'nvim-web-devicons',
  config = configs['barbar.nvim'],
}

M['lualine.nvim'] = {
  'nvim-lualine/lualine.nvim',
  event = 'BufReadPre',
  requires = 'nvim-web-devicons',
  config = configs['lualine.nvim'],
}

M['alpha-nvim'] = {
  'goolord/alpha-nvim',
  cond = function()
    return vim.fn.argc() == 0 and
        vim.o.lines >= 36 and vim.o.columns >= 112
  end,
  requires = 'nvim-web-devicons',
  config = configs['alpha-nvim'],
}

return M
