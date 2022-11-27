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
  vim.keymap.set('n', '<Leader>fd', function() telescope_builtin.lsp_definitions() end, keymap_opts)
  vim.keymap.set('n', '<Leader>ft', function() telescope_builtin.lsp_type_definitions() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fp', function() telescope_builtin.treesitter() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fs', function() telescope_builtin.lsp_document_symbols() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fS', function() telescope_builtin.lsp_workspace_symbols() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fg', function() telescope_builtin.git_files() end, keymap_opts)
  vim.keymap.set('n', '<Leader>fm', function() telescope_builtin.marks() end, keymap_opts)

  telescope.setup({
    defaults = {
      prompt_prefix = '/ ',
      selection_caret = '→ ',
      borderchars = require('utils.static').borders.double_header,
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

M['toggleterm.nvim'] = function()
  local toggleterm = require('toggleterm')
  toggleterm.setup({
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == "horizontal" then
        return 12
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    start_in_insert = true,
    shade_terminals = false,
    open_mapping = '<C-\\>',
    on_open = function(term)
      local keymap_opts = { noremap = true, silent = true, buffer = term.bufnr }
      vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
      vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
      vim.keymap.set('n', '<M-C>', '<cmd>bd!<CR>', keymap_opts)
    end,
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = false,
    direction = 'float',
    float_opts = {
      border = require('utils.static').borders.double_horizontal_clc,
      width = function() return math.floor(0.7 * vim.o.columns) end,
      height = function() return math.floor(0.7 * vim.o.lines) end
    }
  })
end

M['rnvimr'] = function()
  vim.g.rnvimr_enable_ex = 1
  vim.g.rnvimr_enable_picker = 1
  vim.g.rnvimr_enable_bw = 1
  vim.g.rnvimr_ranger_cmd = { 'ranger', '--cmd=set draw_borders both' }
  vim.g.rnvimr_action = {
    ['<A-t>'] = 'NvimEdit tabedit',
    ['<A-s>'] = 'NvimEdit split',
    ['<A-v>'] = 'NvimEdit vsplit',
    ['gw'] = 'JumpNvimCwd',
    ['yw'] = 'EmitRangerCwd'
  }

  vim.keymap.set({ 'n', 't' }, '<M-e>',
      '<cmd>RnvimrToggle<CR>', { noremap = true })
end

M['gitsigns.nvim'] = function()
  require('gitsigns').setup({
    signs = {
      add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      untracked = { hl = 'GitSignsAdd', text = '*', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      changedelete = { hl = 'GitSignsDelete', text = '~', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, {expr=true})

      -- Actions
      map({ 'n', 'v' }, '<leader>gs', gs.stage_hunk)
      map({ 'n', 'v' }, '<leader>gr', gs.reset_hunk)
      map('n', '<leader>gS', gs.stage_buffer)
      map('n', '<leader>gu', gs.undo_stage_hunk)
      map('n', '<leader>gR', gs.reset_buffer)
      map('n', '<leader>gp', gs.preview_hunk)
      map('n', '<leader>gb', function() gs.blame_line { full = false } end)
      map('n', '<leader>gB', function() gs.blame_line { full = true } end)
      map('n', '<leader>gd', gs.diffthis)
      map('n', '<leader>gD', function() gs.diffthis('~') end)

      -- Text object
      map({ 'o', 'x' }, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
      map({ 'o', 'x' }, 'ac', ':<C-U>Gitsigns select_hunk<CR>')
    end,
  })
end

return M
