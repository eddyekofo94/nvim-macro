local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  -- Disable number, relativenumber, and spell check in the built-in terminal
  {
    { 'TermOpen' },
    {
      buffer = 0,
      callback = function()
        vim.wo.spell = false
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.scrolloff = 0
      end
    },
  },

  -- Highlight the selection on yank
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
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
    { 'VimEnter', 'WinEnter' },
    {
      pattern = '*',
      callback = function()
        require('utils.funcs').win_close_jmp()
      end
    },
  },

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      callback = function()
        require('utils.funcs').last_pos_jmp()
      end
    },
  },

  {
    { 'ColorScheme', 'VimEnter' },
    {
      pattern = '*',
      command = 'hi clear SpellBad | hi SpellBad cterm=undercurl gui=undercurl'
    },
  },

  -- Automatically change local current directory
  {
    { 'BufEnter' },
    {
      pattern = '*',
      callback = function ()
        if vim.bo.buftype ~= '' then return end
        local target_dir = require('utils.funcs').git_dir()
        if not target_dir then target_dir = vim.fn.expand('%:p:h') end
        if target_dir then vim.cmd('lcd ' .. target_dir) end
      end
    },
  },
}

set_autocmds(autocmds)
