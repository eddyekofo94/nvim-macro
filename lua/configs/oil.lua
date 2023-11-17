vim.g.loaded_fzf_file_explorer = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local oil = require('oil')
local icons = require('utils.static').icons
local icon_file = vim.trim(icons.File)
local icon_dir = vim.trim(icons.Folder)

oil.setup({
  columns = {
    { 'permissions', highlight = 'Special' },
    { 'size', highlight = 'Operator' },
    { 'mtime', highlight = 'Number' },
    { 'icon', default_file = icon_file, directory = icon_dir },
  },
  win_options = {
    number = false,
    relativenumber = false,
    signcolumn = 'no',
    foldcolumn = '0',
    statuscolumn = '',
  },
  cleanup_delay_ms = 0,
  delete_to_trash = true,
  trash_command = 'trash-put',
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  use_default_keymaps = false,
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['-'] = 'actions.parent',
    ['='] = 'actions.select',
    ['+'] = 'actions.select',
    ['<CR>'] = 'actions.select',
    ['<C-h>'] = 'actions.toggle_hidden',
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['yy'] = 'actions.copy_entry_path',
    ['<C-o>'] = { -- Prevent jumping to file buffers by accident
      mode = 'n',
      expr = true,
      buffer = true,
      desc = 'Jump to previous location in oil buffer.',
      callback = function()
        local jumplist = vim.fn.getjumplist()
        local prevloc = jumplist[1][jumplist[2]]
        return prevloc
            and vim.api.nvim_buf_is_valid(prevloc.bufnr)
            and vim.bo[prevloc.bufnr].ft == 'oil'
            and '<C-o>'
          or '<Ignore>'
      end,
    },
    ['<C-i>'] = {
      mode = 'n',
      expr = true,
      buffer = true,
      desc = 'Jump to previous location in oil buffer.',
      callback = function()
        local jumplist = vim.fn.getjumplist()
        local newloc = jumplist[1][jumplist[2] + 2]
        return newloc
            and vim.api.nvim_buf_is_valid(newloc.bufnr)
            and vim.bo[newloc.bufnr].ft == 'oil'
            and '<C-i>'
          or '<Ignore>'
      end,
    },
  },
  float = {
    border = 'solid',
    win_options = {
      winblend = 0,
    },
  },
  preview = {
    border = 'solid',
    win_options = {
      winblend = 0,
    },
  },
  progress = {
    border = 'solid',
    win_options = {
      winblend = 0,
    },
  },
})

local groupid = vim.api.nvim_create_augroup('OilSyncCwd', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged' }, {
  desc = 'Set cwd to follow directory shown in oil buffers.',
  group = groupid,
  pattern = 'oil:///*',
  callback = function(info)
    if vim.bo[info.buf].filetype == 'oil' then
      local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
      local oildir = vim.fs.normalize(oil.get_current_dir())
      if cwd ~= oildir then
        vim.cmd.lcd(oildir)
      end
    end
  end,
})
vim.api.nvim_create_autocmd('DirChanged', {
  desc = 'Let oil buffers follow cwd.',
  group = groupid,
  callback = function(info)
    if vim.bo[info.buf].filetype == 'oil' then
      vim.defer_fn(function()
        local cwd = vim.fs.normalize(vim.fn.getcwd(vim.fn.winnr()))
        local oildir = vim.fs.normalize(oil.get_current_dir())
        if cwd ~= oildir then
          oil.open(cwd)
        end
      end, 100)
    end
  end,
})

---Set some default hlgroups for oil
---@return nil
local function oil_sethl()
  local sethl = require('utils.hl').set
  sethl(0, 'OilCopy', { fg = 'DiagnosticSignHint', bold = true })
  sethl(0, 'OilMove', { fg = 'DiagnosticSignWarn', bold = true })
  sethl(0, 'OilChange', { fg = 'DiagnosticSignWarn', bold = true })
  sethl(0, 'OilCreate', { fg = 'DiagnosticSignInfo', bold = true })
  sethl(0, 'OilDelete', { fg = 'DiagnosticSignError', bold = true })
end
oil_sethl()

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set some default hlgroups for oil.',
  group = vim.api.nvim_create_augroup('OilSetDefaultHlgroups', {}),
  callback = oil_sethl,
})
