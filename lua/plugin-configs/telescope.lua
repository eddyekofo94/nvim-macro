local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('n', '<Leader>F', [[<cmd>Telescope<CR>]], opts)
map('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<CR>]], opts)
map('n', '<Leader>fof', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], opts)
map('n', '<Leader>f;', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], opts)
map('n', '<Leader>f*', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], opts)
map('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], opts)
map('n', '<Leader>fm', [[<cmd>lua require('telescope.builtin').marks()<CR>]], opts)
map('n', '<Leader>fq', [[<cmd>lua require('telescope.builtin').quickfix()<CR>]], opts)
map('n', '<Leader>fl', [[<cmd>lua require('telescope.builtin').loclist()<CR>]], opts)
map('n', '<Leader>fbf', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], opts)
map('n', '<Leader>fR', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts)
map('n', '<Leader>fa', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<CR>]], opts)
map('n', '<Leader>fe', [[<cmd>lua require('telescope.builtin').diagnostics()<CR>]], opts)
map('n', '<Leader>fd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], opts)
map('n', '<Leader>ftd', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]], opts)
map('n', '<Leader>fi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], opts)
map('n', '<Leader>fp', [[<cmd>lua require('telescope.builtin').treesitter()<CR>]], opts)
map('n', '<Leader>fs', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
map('n', '<Leader>fS', [[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts)
map('n', '<Leader>fg', [[<cmd>lua require('telescope.builtin').git_status()<CR>]], opts)
map('n', '<Leader>fj', [[<cmd>lua require('telescope').extensions.project.project({display_type = 'full'})<CR>]], opts)

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    prompt_prefix = '/ ',
    selection_caret = '→ ',
    borderchars = require('utils.shared').borders.double_header,
    layout_config = {
      horizontal = { prompt_position = 'top' },
      vertical = { prompt_position = 'top' }
    },
    sorting_strategy = 'ascending',
    file_ignore_patterns = { '.git/', '%.pdf', '%.o', '%.zip' },
    preview = { filesize_limit = 5 },
    mappings = {
      i = {
        ['<M-c>'] = actions.close,
        ['<M-x>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-Q>'] = actions.send_selected_to_qflist + actions.open_qflist,
      },

      n = {
        ['q'] = actions.close,
        ['<esc>'] = actions.close,
        ['<M-c>'] = actions.close,
        ['<M-x>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-Q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
      }
    }
  },
  extensions = {
    project = {
      base_dirs = {
        '~/'
      },
      hidden_files = true
    }
  }
}

vim.cmd [[ packadd telescope-fzf-native.nvim ]]
vim.cmd [[ packadd telescope-project.nvim ]]
telescope.load_extension('fzf')
telescope.load_extension('project')
