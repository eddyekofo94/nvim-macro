require('toggleterm').setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 12
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  start_in_insert = false,
  shade_terminals = false,
  open_mapping = [[<C-\>]],
  on_open = function(term)
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>',
                                {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<esc>', '<cmd>close<CR>',
                                {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<C-\\>', '<cmd>close<CR>',
                                {noremap = true, silent = true})
  end,
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = false,
  direction = 'float',
  float_opts = {
    border = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
    width = 120,
    height = 32
  }
}

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = 'lazygit',
  hidden = true,
  dir = 'git_dir',
  direction = 'float',
  float_opts = {
    border = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
    width = 120,
    height = 32
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd [[ startinsert ]]
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>',
                                {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<esc>', '<cmd>close<CR>',
                                {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<C-\\>', '<cmd>close<CR>',
                                {noremap = true, silent = true})
  end
})

function Lazygit_toggle()
  lazygit:toggle()
end

vim.cmd [[ command Git lua Lazygit_toggle()<CR> ]]
vim.cmd [[ command ToggleTermFloat ToggleTerm direction='float' ]]
vim.cmd [[ command ToggleTermHorizontal ToggleTerm direction='horizontal' ]]
vim.cmd [[ command ToggleTermVertical ToggleTerm direction='vertical' ]]
vim.cmd [[ command ToggleTermTab ToggleTerm direction='tab' ]]
