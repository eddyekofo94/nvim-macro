local M = {}

M['telescope.nvim'] = function()
  local telescope = require('telescope')
  local telescope_builtin = require('telescope.builtin')
  local telescope_actions = require('telescope.actions')

  local keymap_opts = { noremap = true, silent = true }
  vim.keymap.set('n', '<Leader>F', function() telescope_builtin.builtin() end, keymap_opts)
  vim.keymap.set('n', '<Leader>ff', function() telescope_builtin.find_files() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fo', function() telescope_builtin.oldfiles() end, keymap_opts)
  vim.keymap.set('n', '<Leader>f;', function() telescope_builtin.live_grep() end, keymap_opts)
  vim.keymap.set('n', '<Leader>f*', function() telescope_builtin.grep_string() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fh', function() telescope_builtin.help_tags() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fb', function() telescope_builtin.current_buffer_fuzzy_find() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fR', function() telescope_builtin.lsp_references() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fa', function() telescope_builtin.lsp_code_actions() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fe', function() telescope_builtin.diagnostics() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fp', function() telescope_builtin.treesitter() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fs', function() telescope_builtin.lsp_document_symbols() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fS', function() telescope_builtin.lsp_workspace_symbols() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fg', function() telescope_builtin.git_status() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fm', function() telescope_builtin.marks() end, keymap_opts)

  telescope.setup({
    defaults = {
      prompt_prefix = '/ ',
      selection_caret = '→ ',
      borderchars = require('utils.static').borders.single,
      layout_config = {
        horizontal = { prompt_position = 'top' },
        vertical = { prompt_position = 'top' }
      },
      sorting_strategy = 'ascending',
      file_ignore_patterns = { '.git/', '%.pdf', '%.o', '%.zip' },
      mappings = {
        i = {
          ['<M-c>'] = telescope_actions.close,
          ['<M-s>'] = telescope_actions.select_horizontal,
          ['<M-v>'] = telescope_actions.select_vertical,
          ['<M-t>'] = telescope_actions.select_tab,
          ['<M-q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
          ['<M-Q>'] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,
        },

        n = {
          ['q'] = telescope_actions.close,
          ['<esc>'] = telescope_actions.close,
          ['<M-c>'] = telescope_actions.close,
          ['<M-s>'] = telescope_actions.select_horizontal,
          ['<M-v>'] = telescope_actions.select_vertical,
          ['<M-t>'] = telescope_actions.select_tab,
          ['<M-q>'] = telescope_actions.send_to_qflist + telescope_actions.open_qflist,
          ['<M-Q>'] = telescope_actions.send_selected_to_qflist + telescope_actions.open_qflist,
          ['<C-n>'] = telescope_actions.move_selection_next,
          ['<C-p>'] = telescope_actions.move_selection_previous,
        },
      },
    },
  })

  -- load telescope extensions
  telescope.load_extension('fzf')
end

M['undotree'] = function()
  vim.g.undotree_SplitWidth = 30
  vim.g.undotree_ShortIndicators = 1
  vim.g.undotree_WindowLayout = 3
  vim.g.undotree_DiffpanelHeight = 16
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.api.nvim_set_keymap('n', '<Leader>uu', '<cmd>UndotreeToggle<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<Leader>uo', '<cmd>UndotreeShow<CR>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<Leader>uq', '<cmd>UndotreeHide<CR>', { noremap = true })
end

M['vim-floaterm'] = function()
  vim.cmd([[
    let g:floaterm_width = 0.7
    let g:floaterm_height = 0.8
    let g:floaterm_opener = 'edit'
    nnoremap <silent> <M-i> <Cmd>FloatermNew lazygit<CR>
    nnoremap <silent> <M-e> <Cmd>FloatermNew ranger<CR>
    tnoremap <silent> <M-i> <Cmd>FloatermKill lazygit<CR>
    tnoremap <silent> <M-e> <Cmd>FloatermKill ranger<CR>
    nnoremap <silent> <C-\> <Cmd>FloatermToggle<CR>
    tnoremap <silent> <C-\> <Cmd>FloatermToggle<CR>
    tnoremap <silent> <C-p> <Cmd>FloatermPrev<CR>
    tnoremap <silent> <C-n> <Cmd>FloatermNext<CR>
  ]])
end

return M
