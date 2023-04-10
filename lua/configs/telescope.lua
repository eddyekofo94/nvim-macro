local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local telescope_actions = require('telescope.actions')

local keymap_opts = { noremap = true, silent = true }
vim.keymap.set('n', '<Leader>F', function() telescope_builtin.builtin() end, keymap_opts)
vim.keymap.set('n', '<Leader>f', function() telescope_builtin.builtin() end, keymap_opts)
vim.keymap.set('n', '<Leader>ff', function() telescope_builtin.find_files() end, keymap_opts)
vim.keymap.set('n', '<Leader>fo', function() telescope_builtin.oldfiles() end, keymap_opts)
vim.keymap.set('n', '<Leader>f;', function() telescope_builtin.live_grep() end, keymap_opts)
vim.keymap.set('n', '<Leader>f*', function() telescope_builtin.grep_string() end, keymap_opts)
vim.keymap.set('n', '<Leader>fh', function() telescope_builtin.help_tags() end, keymap_opts)
vim.keymap.set('n', '<Leader>fb', function() telescope_builtin.current_buffer_fuzzy_find() end, keymap_opts)
vim.keymap.set('n', '<Leader>fr', function() telescope_builtin.lsp_references({ jump_type = 'never', include_current_line = true }) end, keymap_opts)
vim.keymap.set('n', '<Leader>fd', function() telescope_builtin.lsp_definitions({ jump_type = 'never', include_current_line = true }) end, keymap_opts)
vim.keymap.set('n', '<Leader>fa', function() telescope_builtin.lsp_code_actions() end, keymap_opts)
vim.keymap.set('n', '<Leader>fe', function() telescope_builtin.diagnostics() end, keymap_opts)
vim.keymap.set('n', '<Leader>fp', function() telescope_builtin.treesitter() end, keymap_opts)
vim.keymap.set('n', '<Leader>fs', function() telescope_builtin.lsp_document_symbols() end, keymap_opts)
vim.keymap.set('n', '<Leader>fS', function() telescope_builtin.lsp_workspace_symbols() end, keymap_opts)
vim.keymap.set('n', '<Leader>fg', function() telescope_builtin.git_status() end, keymap_opts)
vim.keymap.set('n', '<Leader>fm', function() telescope_builtin.marks() end, keymap_opts)
vim.keymap.set('n', '<Leader>fu', function() telescope.extensions.undo.undo() end, keymap_opts)
vim.keymap.set('n', '<Leader>f<Esc>', '', keymap_opts)

telescope.setup({
  defaults = {
    prompt_prefix = '/ ',
    selection_caret = '→ ',
    borderchars = require('utils.static').borders.empty,
    layout_strategy = 'flex',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        width = 0.8,
        height = 0.8,
        preview_width = 0.5,
      },
      vertical = {
        prompt_position = 'top',
        width = 0.8,
        height = 0.8,
        mirror = true,
      },
    },
    sorting_strategy = 'ascending',
    file_ignore_patterns = { '.git/', '%.pdf', '%.o', '%.zip' },
    mappings = {
      i = {
        ['<M-c>'] = telescope_actions.close,
        ['<M-s>'] = telescope_actions.select_horizontal,
        ['<M-v>'] = telescope_actions.select_vertical,
        ['<M-t>'] = telescope_actions.select_tab,
        ['<M-Q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
      },

      n = {
        ['q'] = telescope_actions.close,
        ['<esc>'] = telescope_actions.close,
        ['<M-c>'] = telescope_actions.close,
        ['<M-s>'] = telescope_actions.select_horizontal,
        ['<M-v>'] = telescope_actions.select_vertical,
        ['<M-t>'] = telescope_actions.select_tab,
        ['<M-Q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
        ['<C-n>'] = telescope_actions.move_selection_next,
        ['<C-p>'] = telescope_actions.move_selection_previous,
      },
    },
  },
  extensions = {
    undo = {
      use_delta = true,
      mappings = {
        i = {
          ['<CR>'] = require('telescope-undo.actions').restore,
        },
        n = {
          ['<CR>'] = require('telescope-undo.actions').restore,
          ['ya'] = require("telescope-undo.actions").yank_additions,
          ['yd'] = require("telescope-undo.actions").yank_deletions,
        },
      },
    },
  },
})

-- load telescope extensions
telescope.load_extension('fzf')
telescope.load_extension('undo')
