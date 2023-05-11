local telescope = require('telescope')
local telescope_builtin = require('telescope.builtin')
local telescope_actions = require('telescope.actions')

-- stylua: ignore start
vim.keymap.set('n', '<Leader>F',  function() telescope_builtin.builtin() end)
vim.keymap.set('n', '<Leader>f',  function() telescope_builtin.builtin() end)
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
vim.keymap.set('n', '<Leader>f<Esc>', '<Ignore>')
-- stylua: ignore end

-- Workaround for nvim-telescope/telescope.nvim #2501
-- to prevent opening files in insert mode
vim.api.nvim_create_autocmd('WinLeave', {
  group = vim.api.nvim_create_augroup('TelescopeConfig', {}),
  callback = function(info)
    if
      vim.bo[info.buf].ft == 'TelescopePrompt'
      and vim.startswith(vim.fn.mode(), 'i')
    then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
        'in',
        false
      )
    end
  end,
})

-- Dropdown layout for telescope
local layout_dropdown = {
  previewer = false,
  layout_config = {
    width = 0.5,
    height = 0.5,
  },
}

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
    colorscheme = vim.tbl_deep_extend('force', layout_dropdown, {
      enable_preview = true,
    }),
    commands = layout_dropdown,
    command_history = layout_dropdown,
    filetypes = layout_dropdown,
    keymaps = layout_dropdown,
    lsp_references = {
      include_current_line = true,
      jump_type = 'never',
    },
    lsp_definitions = {
      jump_type = 'never',
    },
    vim_options = layout_dropdown,
    registers = layout_dropdown,
    reloader = layout_dropdown,
    search_history = layout_dropdown,
    spell_suggest = layout_dropdown,
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
if
  not vim.tbl_isempty(
    vim.fs.find({ 'libfzf.so' }, { path = vim.g.package_path, type = 'file' })
  )
then
  telescope.load_extension('fzf')
end
telescope.load_extension('undo')
