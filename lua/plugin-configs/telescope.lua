local map = vim.keymap.set
local opts = { noremap = true, silent = true }
map('n', '<Leader>F', [[<cmd>Telescope<CR>]], opts)
map('n', '<Leader>ff', function() require('telescope.builtin').find_files() end, opts)
map('n', '<Leader>fof', function() require('telescope.builtin').oldfiles() end, opts)
map('n', '<Leader>f;', function() require('telescope.builtin').live_grep() end, opts)
map('n', '<Leader>f*', function() require('telescope.builtin').grep_string() end, opts)
map('n', '<Leader>fh', function() require('telescope.builtin').help_tags() end, opts)
map('n', '<Leader>fm', function() require('telescope.builtin').marks() end, opts)
map('n', '<Leader>fq', function() require('telescope.builtin').quickfix() end, opts)
map('n', '<Leader>fl', function() require('telescope.builtin').loclist() end, opts)
map('n', '<Leader>fbf', function() require('telescope.builtin').current_buffer_fuzzy_find() end, opts)
map('n', '<Leader>fR', function() require('telescope.builtin').lsp_references() end, opts)
map('n', '<Leader>fa', function() require('telescope.builtin').lsp_code_actions() end, opts)
map('n', '<Leader>fe', function() require('telescope.builtin').diagnostics() end, opts)
map('n', '<Leader>fd', function() require('telescope.builtin').lsp_definitions() end, opts)
map('n', '<Leader>ftd', function() require('telescope.builtin').lsp_type_definitions() end, opts)
map('n', '<Leader>fi', function() require('telescope.builtin').lsp_implementations() end, opts)
map('n', '<Leader>fp', function() require('telescope.builtin').treesitter() end, opts)
map('n', '<Leader>fs', function() require('telescope.builtin').lsp_document_symbols() end, opts)
map('n', '<Leader>fS', function() require('telescope.builtin').lsp_workspace_symbols() end, opts)
map('n', '<Leader>fg', function() require('telescope.builtin').git_status() end, opts)
map('n', '<Leader>fgf', function() require('telescope.builtin').git_files() end, opts)
map('n', '<Leader>fj', function() require('telescope').extensions.project.project({ display_type = 'full' }) end, opts)

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup {
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
        ['<M-;>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-Q>'] = actions.send_selected_to_qflist + actions.open_qflist,
      },

      n = {
        ['q'] = actions.close,
        ['<esc>'] = actions.close,
        ['<M-c>'] = actions.close,
        ['<M-;>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
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
