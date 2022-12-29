local M = {}
local configs = require('modules.ui.configs')

M['barbar.nvim'] = {
  'romgrk/barbar.nvim',
  cond = function()
    -- try load barbar every time a new buffer is created
    vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufWritePost' }, {
      pattern = '*',
      callback = function()
        -- load barbar only once
        if not vim.g.loaded_barbar and
            -- load barbar only if there's more than 1 listed buffer
          #vim.fn.getbufinfo({ buflisted = true }) > 1 then
          vim.g.loaded_barbar = true
          vim.cmd('packadd barbar.nvim')
          require('modules.ui.configs')['barbar.nvim']()
        end
      end
    })
    -- load barbar at startup if more
    -- than one argument passed to nvim
    return vim.fn.argc() > 1
  end,
  requries = 'nvim-web-devicons',
  config = configs['barbar.nvim'],
}

M['lualine.nvim'] = {
  'nvim-lualine/lualine.nvim',
  -- load lualine only when a real
  -- file is about to open
  event = 'BufReadPre',
  requires = 'nvim-web-devicons',
  config = configs['lualine.nvim'],
}

M['alpha-nvim'] = {
  'goolord/alpha-nvim',
  cond = function()
    -- load alpha only when no argument
    -- passed to nvim at startup
    return vim.fn.argc() == 0 and
        -- alpha will break if there's no enough space
        vim.o.lines >= 36 and vim.o.columns >= 80
  end,
  requires = 'nvim-web-devicons',
  config = configs['alpha-nvim'],
}

return M
