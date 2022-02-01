local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], opts)
map('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)
map('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], opts)
map('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], opts)

require('telescope').setup{
  mappings = {
        i = {
      ['<C-n>'] = require('telescope.actions').move_selection_next,
      ['<C-p>'] = require('telescope.actions').move_selection_previous,

      ['<M-c>'] = require('telescope.actions').close,

      ['<Down>'] = require('telescope.actions').move_selection_next,
      ['<Up>'] = require('telescope.actions').move_selection_previous,

      ['<CR>'] = require('telescope.actions').select_default,
      ['<M-x>'] = require('telescope.actions').select_horizontal,
      ['<M-v>'] = require('telescope.actions').select_vertical,
      ['<M-t>'] = require('telescope.actions').select_tab,

      ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
      ['<C-d>'] = require('telescope.actions').preview_scrolling_down,

      ['<PageUp>'] = require('telescope.actions').results_scrolling_up,
      ['<PageDown>'] = require('telescope.actions').results_scrolling_down,

      ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
      ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,
      ['<M-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
      ['<M-Q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,
      ['<C-l>'] = require('telescope.actions').complete_tag,
      ['<C-_>'] = require('telescope.actions').which_key, -- keys from pressing <C-/>
      ['<C-w>'] = { '<c-s-w>', type = 'command' },
    },

    n = {
      ['q'] = require('telescope.actions').close,
      ['<esc>'] = require('telescope.actions').close,
      ['<CR>'] = require('telescope.actions').select_default,
      ['<M-x>'] = require('telescope.actions').select_horizontal,
      ['<M-v>'] = require('telescope.actions').select_vertical,
      ['<M-t>'] = require('telescope.actions').select_tab,

      ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
      ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,
      ['<M-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
      ['<M-Q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,

      -- TODO: This would be weird if we switch the ordering.
      ['j'] = require('telescope.actions').move_selection_next,
      ['k'] = require('telescope.actions').move_selection_previous,
      ['H'] = require('telescope.actions').move_to_top,
      ['M'] = require('telescope.actions').move_to_middle,
      ['L'] = require('telescope.actions').move_to_bottom,

      ['<Down>'] = require('telescope.actions').move_selection_next,
      ['<Up>'] = require('telescope.actions').move_selection_previous,
      ['gg'] = require('telescope.actions').move_to_top,
      ['G'] = require('telescope.actions').move_to_bottom,

      ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
      ['<C-d>'] = require('telescope.actions').preview_scrolling_down,

      ['<PageUp>'] = require('telescope.actions').results_scrolling_up,
      ['<PageDown>'] = require('telescope.actions').results_scrolling_down,

      ['?'] = require('telescope.actions').which_key,
    },
  }
}
