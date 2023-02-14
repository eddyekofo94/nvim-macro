local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  -- Highlight the selection on yank
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
      end
    },
  },

  -- Autosave on focus change
  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      pattern = '*',
      command = 'silent! wall',
      nested = true
    },
  },

  -- Jump to last accessed window on closing the current one
  {
    { 'WinEnter' },
    {
      pattern = '*',
      callback = function() require('utils.funcs').win_close_jmp() end,
    },
  },

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      callback = function() require('utils.funcs').last_pos_jmp() end,
    },
  },

  -- Automatically change local current directory
  {
    { 'WinEnter', 'BufWinEnter' },
    {
      pattern = '*',
      callback = function(tbl)
        if tbl.file == '' then return end
        local proj_dir = require('utils.funcs').proj_dir(tbl.file)
        if proj_dir then
          vim.defer_fn(function() vim.cmd.lcd(proj_dir) end, 100)
        end
      end,
    },
  },

  -- Automatically create missing directories
  {
    { 'BufWritePre' },
    {
      pattern = '*',
      callback = function()
        vim.fn.mkdir(vim.fn.expand('%:p:h'), 'p')
      end,
    },
  },

  -- Restore dark/light background from ShaDa
  {
    { 'BufReadPre', 'UIEnter' },
    {
      callback = function()
        if not vim.g.background_restored then
          vim.opt.background = vim.g.BACKGROUND or 'dark'
          vim.g.background_restored = true
        end
      end,
      once = true,
    },
  },
}

set_autocmds(autocmds)
