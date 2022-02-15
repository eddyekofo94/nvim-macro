require('toggleterm').setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 10
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  start_in_insert = false,
  shade_terminals = false,
  open_mapping = [[<C-\>]],
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction = 'horizontal'
}

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({
  cmd = 'lazygit',
  hidden = true,
  start_in_insert = false,
  dir = 'git_dir',
  direction = 'float',
  float_opts = {
    border = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
    width = 150,
    height = 40
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
