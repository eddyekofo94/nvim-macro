local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local telescope_actions = require('telescope.actions')

vim.keymap.set('n', '<Leader>F', function() telescope_builtin.builtin() end)
vim.keymap.set('n', '<Leader>f', function() telescope_builtin.builtin() end)
vim.keymap.set('n', '<Leader>ff', function() telescope_builtin.find_files() end)
vim.keymap.set('n', '<Leader>fo', function() telescope_builtin.oldfiles() end)
vim.keymap.set('n', '<Leader>f;', function() telescope_builtin.live_grep() end)
vim.keymap.set('n', '<Leader>f*', function() telescope_builtin.grep_string() end)
vim.keymap.set('n', '<Leader>fh', function() telescope_builtin.help_tags() end)
vim.keymap.set('n', '<Leader>f/', function() telescope_builtin.current_buffer_fuzzy_find() end)
vim.keymap.set('n', '<Leader>fb', function() telescope_builtin.buffers() end)
vim.keymap.set('n', '<Leader>fr', function() telescope_builtin.lsp_references() end)
vim.keymap.set('n', '<Leader>fd', function() telescope_builtin.lsp_definitions() end)
vim.keymap.set('n', '<Leader>fa', function() telescope_builtin.lsp_code_actions() end)
vim.keymap.set('n', '<Leader>fe', function() telescope_builtin.diagnostics() end)
vim.keymap.set('n', '<Leader>fp', function() telescope_builtin.treesitter() end)
vim.keymap.set('n', '<Leader>fs', function() telescope_builtin.lsp_document_symbols() end)
vim.keymap.set('n', '<Leader>fS', function() telescope_builtin.lsp_workspace_symbols() end)
vim.keymap.set('n', '<Leader>fg', function() telescope_builtin.git_status() end)
vim.keymap.set('n', '<Leader>fm', function() telescope_builtin.marks() end)
vim.keymap.set('n', '<Leader>fu', function() telescope.extensions.undo.undo() end)
vim.keymap.set('n', '<Leader>f<Esc>', '')

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
        ['<M-Q>'] = telescope_actions.send_to_qflist
          + telescope_actions.open_qflist,
      },

      n = {
        ['q'] = telescope_actions.close,
        ['<esc>'] = telescope_actions.close,
        ['<C-n>'] = telescope_actions.move_selection_next,
        ['<C-p>'] = telescope_actions.move_selection_previous,
        ['<M-c>'] = telescope_actions.close,
        ['<M-s>'] = telescope_actions.select_horizontal,
        ['<M-v>'] = telescope_actions.select_vertical,
        ['<M-t>'] = telescope_actions.select_tab,
        ['<M-Q>'] = telescope_actions.send_to_qflist
          + telescope_actions.open_qflist,
      },
    },
  },
  pickers = {
    colorscheme = {
      enable_preview = true,
    },
    lsp_references = {
      include_current_line = true,
      jump_type = 'never',
    },
    lsp_definitions = {
      jump_type = 'never',
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
          ['ya'] = require('telescope-undo.actions').yank_additions,
          ['yd'] = require('telescope-undo.actions').yank_deletions,
        },
      },
    },
  },
})

-- load telescope extensions
telescope.load_extension('fzf')
telescope.load_extension('undo')
