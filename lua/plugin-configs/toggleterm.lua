local M = {}

require('toggleterm').setup {
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 12
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  start_in_insert = true,
  shade_terminals = false,
  open_mapping = [[<C-\>]],
  on_open = function(term)
    local keymap_opts = { noremap = true, silent = true, buffer = term.bufnr }
    vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
    vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
    vim.keymap.set('n', '<C-\\>', '<cmd>close<CR>', keymap_opts)
    vim.keymap.set('n', '<M-d>', '<cmd>bd!<CR>', keymap_opts)
  end,
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = false,
  direction = 'float',
  float_opts = {
    border = require('utils.shared').borders.double_horizontal_clc,
    width = function() return math.floor(0.8 * vim.o.columns) end,
    height = function() return math.floor(0.8 * vim.o.lines) end
  }
}


local Terminal = require('toggleterm.terminal').Terminal
local git_dir = require('toggleterm.utils').git_dir

function M.lazygit_toggle()
  local directory = git_dir()
  if directory == nil then
    print('Git: Not in a git directory')
    return
  end
  if directory ~= vim.g.git_pred_dir then
    vim.g.git_pred_dir = directory
    M.Lazygit = Terminal:new({
      cmd = 'lazygit -p ' .. directory,
      hidden = true,
      -- function to run on opening the terminal
      on_open = function(term)
        local keymap_opts = { noremap = true, silent = true, buffer = term.bufnr }
        vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set('n', '<M-d>', '<cmd>bd!<CR>', keymap_opts)
        vim.keymap.set({ 't', 'n' }, '<C-\\>', '<cmd>close<CR>', keymap_opts)
      end
    })
  end
  M.Lazygit:toggle()
end

-- Source:
-- https://www.reddit.com/r/neovim/comments/r5i9zi/comment/hmnhqwu/?utm_source=share&utm_medium=web2x&context=3
function M.vifm_toggle(args)

  local Path = require 'plenary.path'
  local temp_file = vim.fn.tempname() -- Temp file for writing file name to
  local temp_dir = vim.fn.tempname() -- Temp file for writing directory name to

  -- Fallback to the default args if vifm_args is not provided
  if args == nil then args = {} end
  if args.vifm_args == nil or args.vifm_args == '' then args.vifm_args = git_dir() end
  if args.vifm_args == nil or args.vifm_args == '' then args.vifm_args = vim.fn.getcwd() end
  -- If args are different from previous args, create new vifm instance and set g:vifm_pred_args
  if args.force_update == true or args.vifm_args ~= vim.g.vifm_pred_args then
    vim.g.vifm_pred_args = args.vifm_args
    M.Vifm = Terminal:new {
      cmd = ([[vifm %s --choose-files '%s' --choose-dir '%s']]):format(args.vifm_args, temp_file, temp_dir),
      hidden = true,
      on_open = function(term)
        -- Keymap to close the vifm terminal
        local keymap_opts = { noremap = true, silent = true, buffer = term.bufnr }
        vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set('n', '<M-d>', 'i:qa!<CR>', keymap_opts)
        vim.keymap.set('n', '<M-;>', function() M.vifm_close_silent(term) end, keymap_opts)
        vim.keymap.set('n', '<M-c>', function() M.vifm_close_silent(term) end, keymap_opts)
        vim.keymap.set('n', '<C-w>c', function() M.vifm_close_silent(term) end, keymap_opts)
        vim.keymap.set({ 't', 'n' }, '<leader>V', function() M.vifm_close_silent(term) end, keymap_opts)
        vim.keymap.set({ 't', 'n' }, '<leader>v', function() M.vifm_close_silent(term) end, keymap_opts)
        vim.keymap.set({ 't', 'n' }, '<C-\\>', function() M.vifm_close_silent(term) end, keymap_opts)
        -- Keymap to open file in current window
        vim.keymap.set('t', '<CR>', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'e', type = 'file' })
          local key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        vim.keymap.set('t', 'l', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'e', type = 'file' })
          local key = vim.api.nvim_replace_termcodes('l', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        vim.keymap.set('t', 'i', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'e', type = 'file' })
          local key = vim.api.nvim_replace_termcodes('i', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        -- Keymaps to open file in vertical split
        vim.keymap.set('t', '<M-v>', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'vsplit|e', type = 'file' })
          local key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        -- Keymaps to open file in horizontal split
        vim.keymap.set('t', '<M-s>', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'split|e', type = 'file' })
          local key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        -- Keymaps to open file in new tab
        vim.keymap.set('t', '<M-t>', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'tabnew|e', type = 'file' })
          local key = vim.api.nvim_replace_termcodes('<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        -- Keymap to change working directory
        vim.keymap.set('t', '<leader>cd', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'cd', type = 'dir' })
          local key = vim.api.nvim_replace_termcodes(':qa<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        vim.keymap.set('t', '<leader>lcd', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'lcd', type = 'dir' })
          local key = vim.api.nvim_replace_termcodes(':qa<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
        vim.keymap.set('t', '<leader>tcd', function()
          require('plugin-configs.toggleterm').vifm_set_open_method({ cmd = 'tcd', type = 'dir' })
          local key = vim.api.nvim_replace_termcodes(':qa<CR>', true, true, true)
          vim.api.nvim_feedkeys(key, 'nt', false)
        end, keymap_opts)
      end,
      on_close = function()
        local file_name = Path:new(temp_file):read()
        local dir_name = Path:new(temp_dir):read()
        local cmd = M.open_method.cmd
        if cmd == nil or cmd == '' then return end
        local targets
        if M.open_method.type == 'dir' then targets = dir_name
        elseif M.open_method.type == 'file' then targets = file_name end
        if targets == nil or targets == '' then return end
        local cmds = ''
        for target in targets:gmatch('[^\r\n]+') do
          cmds = cmds .. cmd .. ' ' .. target .. '|'
        end
        vim.schedule(function() vim.cmd(cmds) end)
      end
    }
  end
  M.Vifm:toggle()
end

-- Start vifm at directory containing the current file,
-- or find current file in vifm.
-- Finding files always force update vifm
function M.vifm_current_file(find_file)
  local force_update = find_file or vim.fn.expand('%:p') ~= vim.g.vifm_pred_file
  vim.g.vifm_pred_file = vim.fn.expand('%:p')
  M.vifm_toggle({ vifm_args = vim.fn.expand('%:p:h'), force_update = force_update })
  M.force_update = false
end

-- Close vifm terminal silently (without open any file)
function M.vifm_close_silent(vifm_term)
  -- set on_close to false temporarily to avoid triggering
  -- the on_close func if we simply want to close the vifm
  local temp = vifm_term.on_close
  vifm_term.on_close = false
  vifm_term:close()
  vifm_term.on_close = temp
end

M.open_method = {}
function M.vifm_set_open_method(method)
  M.open_method.cmd = method.cmd
  M.open_method.type = method.type
end

vim.cmd [[ command ToggleTermFloat ToggleTerm direction='float' ]]
vim.cmd [[ command ToggleTermHorizontal ToggleTerm direction='horizontal' ]]
vim.cmd [[ command ToggleTermVertical ToggleTerm direction='vertical' ]]
vim.cmd [[ command ToggleTermTab ToggleTerm direction='tab' ]]
vim.cmd [[ command Git lua require('plugin-configs.toggleterm').lazygit_toggle() ]]
vim.cmd [[ command -nargs=* Vifm lua require('plugin-configs.toggleterm').vifm_toggle({vifm_args = <q-args>, force_update = true}) ]]
vim.cmd [[ command VifmCurrentFileFind lua require('plugin-configs.toggleterm').vifm_current_file(true) ]]
vim.keymap.set('n', '<leader>V', function() M.vifm_toggle() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>V', function() M.vifm_toggle({ force_update = true }) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>v', function() M.vifm_current_file() end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>v', function() M.vifm_current_file(true) end, { noremap = true, silent = true })

return M
