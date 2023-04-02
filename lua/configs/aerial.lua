local aerial = require('aerial')

aerial.setup({
  keymaps = {
    ['<M-v>'] = 'actions.jump_vsplit',
    ['<M-s>'] = 'actions.jump_split',
    ['<Tab>'] = 'actions.scroll',
    ['p'] = 'actions.prev_up',
    ['<CR>'] = {
      callback = function()
        local is_floating = vim.api.nvim_win_get_config(0).zindex ~= nil
        aerial.select()
        if is_floating then
          aerial.close()
        end
      end,
    },
    ['g?'] = 'actions.show_help',
    ['?'] = false,
    ['<C-v>'] = false,
    ['<C-s>'] = false,
    ['l'] = false,
    ['L'] = false,
    ['h'] = false,
    ['H'] = false,
  },
  attach_mode = 'window',
  backends = { 'lsp', 'treesitter', 'markdown', 'man' },
  disable_max_lines = 8192,
  filter_kind = false,
  icons = require('utils.static').icons,
  ignore = {
    filetypes = { 'aerial', 'help', 'alpha', 'undotree', 'TelescopePrompt' },
  },
  link_folds_to_tree = false,
  link_tree_to_folds = false,
  manage_folds = false,
  layout = {
    default_direction = 'float',
    max_width = 0.5,
    min_width = 0.25,
  },
  float = {
    border = 'shadow',
    relative = 'editor',
    max_height = 0.6,
  },
  show_guides = true,
  treesitter = { update_delay = 10 },
  markdown = { update_delay = 10 },
})

vim.keymap.set('n', '<Leader>o', '<Cmd>AerialToggle float<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>O', '<Cmd>AerialToggle right<CR>', { noremap = true })
