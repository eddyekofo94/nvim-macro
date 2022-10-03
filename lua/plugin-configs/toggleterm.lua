local M = {}

M.toggleterm = require('toggleterm')
M.opts = {
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
  open_mapping = [[<C-\><C-\>]],
  on_open = function(term)
    local keymap_opts = { noremap = true, silent = true, buffer = term.bufnr }
    vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
    vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
    vim.keymap.set('n', '<M-C>', '<cmd>bd!<CR>', keymap_opts)
  end,
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = false,
  direction = 'float',
  float_opts = {
    border = require('utils.static').borders.double_horizontal_clc,
    width = function() return math.floor(0.7 * vim.o.columns) end,
    height = function() return math.floor(0.7 * vim.o.lines) end
  }
}
M.toggleterm.setup(M.opts)


M.Terminal = require('toggleterm.terminal').Terminal
M.git_dir = require('toggleterm.utils').git_dir

function M.lazygit_toggle()
  local directory = M.git_dir()
  if directory == nil then
    vim.notify('Git: Not in a git directory', vim.log.levels.WARN)
    return
  end
  if directory ~= vim.g.git_pred_dir then
    vim.g.git_pred_dir = directory
    M.Lazygit = M.Terminal:new({
      cmd = 'lazygit -p ' .. directory,
      hidden = true,
      -- function to run on opening the terminal
      on_open = function(term)
        local keymap_opts = { noremap = true, silent = true, buffer = term.bufnr }
        vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set('n', '<M-C>', '<cmd>bd!<CR>', keymap_opts)
        vim.keymap.set({ 't', 'n' }, '<C-\\>g', '<cmd>close<CR>', keymap_opts)
        vim.keymap.set({ 't', 'n' }, '<C-\\><C-g>', '<cmd>close<CR>', keymap_opts)
      end
    })
  end
  M.Lazygit:toggle()
end

vim.cmd [[ command Git lua require('plugin-configs.toggleterm').lazygit_toggle() ]]
vim.keymap.set('n', '<C-\\>g', function() M.lazygit_toggle() end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-\\><C-g>', function() M.lazygit_toggle() end, { noremap = true, silent = true })

return M
