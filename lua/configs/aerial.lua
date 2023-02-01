require('aerial').setup({
  keymaps = {
    ['<M-v>'] = 'actions.jump_vsplit',
    ['<M-s>'] = 'actions.jump_split',
    ['<Tab>'] = 'actions.scroll',
    ['p'] = 'actions.prev_up',

    ['?'] = false,
    ['<C-v>'] = false,
    ['<C-s>'] = false,
    ['[['] = false,
    [']]'] = false,
    ['l'] = false,
    ['L'] = false,
    ['h'] = false,
    ['H'] = false,
  },
  attach_mode = 'window',
  backends = { 'lsp', 'markdown', 'man' },
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
    border = 'single',
    relative = 'editor',
    max_height = 0.7,
  },
  close_on_select = true,
  show_guides = true,
  treesitter = { update_delay = 10 },
  markdown = { update_delay = 10 },
})

vim.keymap.set('n', '<Leader>o', '<Cmd>AerialToggle float<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>O', '<Cmd>AerialToggle right<CR>', { noremap = true })
