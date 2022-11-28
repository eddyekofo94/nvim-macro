local funcs = require('utils.funcs')
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
      callback = funcs.win_close_jmp
    },
  },

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      callback = funcs.last_pos_jmp
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
      callback = funcs.autocd
    },
  },
}

set_autocmds(autocmds)
