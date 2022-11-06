-- Disable number, relativenumber, and spell check in the built-in terminal
vim.api.nvim_create_autocmd(
  { 'TermOpen' },
  {
    buffer = 0,
    callback = function()
      vim.wo.spell = false
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.scrolloff = 0
    end
  }
)

-- Highlight the selection on yank
vim.api.nvim_create_autocmd(
  { 'TextYankPost' },
  {
    pattern = '*',
    callback = function()
      vim.highlight.on_yank({ higroup = 'Visual', timeout = 300 })
    end
  }
)

-- Autosave on focus change
vim.api.nvim_create_autocmd(
  { 'BufLeave', 'WinLeave', 'FocusLost' },
  {
    pattern = '*',
    command = 'silent! wall',
    nested = true
  }
)

-- Jump to last accessed window on closing the current one
vim.api.nvim_create_autocmd(
  { 'VimEnter', 'WinEnter' },
  {
    pattern = '*',
    callback = function()
      require('utils.funcs').win_close_jmp()
    end
  }
)

-- Last-position-jump
vim.api.nvim_create_autocmd(
  { 'BufReadPost' },
  {
    pattern = '*',
    callback = function()
      require('utils.funcs').last_pos_jmp()
    end
  }
)

vim.api.nvim_create_autocmd(
  { 'InsertEnter' },
  {
  pattern = '*',
  command = 'set nohlsearch'
  }
)

vim.api.nvim_create_autocmd(
  { 'ColorScheme', 'VimEnter' },
  {
    pattern = '*',
    command = 'hi clear SpellBad | hi SpellBad cterm=undercurl gui=undercurl'
  }
)

-- Used to restore the expandtab setting after temporarily
-- forcing expandtab if have text before cursor, see the
-- corresponding keymap in keymaps.lua
vim.api.nvim_create_autocmd(
  { 'TextChangedI' },
  {
    pattern = '*',
    callback = function ()
      -- Set expandtab only when we have modified it before
      if vim.b.old_expandtab == false then
        vim.bo.expandtab = false
      end
    end
  }
)

-- Automatically change local current directory
vim.api.nvim_create_autocmd(
  { 'BufEnter' },
  {
    pattern = '*',
    callback = function ()
      if vim.bo.buftype ~= '' then return end
      local target_dir = require('utils.funcs').git_dir()
      if not target_dir then target_dir = vim.fn.expand('%:p:h') end
      if target_dir then vim.cmd('lcd ' .. target_dir) end
    end
  }
)
