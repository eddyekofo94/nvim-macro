require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '│-', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>gs', gs.stage_hunk)
    map({'n', 'v'}, '<leader>gr', gs.reset_hunk)
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line{full=true} end)
    map('n', '<leader>gtb', gs.toggle_current_line_blame)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)
    map('n', '<leader>gtd', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ic', ':<C-U>Gitsigns select_hunk<CR>')
  end

  -- on_attach = function(bufnr)
  --   local function map(mode, lhs, rhs, opts)
  --       opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
  --       vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  --   end

  --   -- Navigation
  --   map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
  --   map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

  --   -- Actions
  --   map('n', '<leader>gs', ':Gitsigns stage_hunk<CR>')
  --   map('v', '<leader>gs', ':Gitsigns stage_hunk<CR>')
  --   map('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
  --   map('v', '<leader>gr', ':Gitsigns reset_hunk<CR>')
  --   map('n', '<leader>gS', '<cmd>Gitsigns stage_buffer<CR>')
  --   map('n', '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<CR>')
  --   map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<CR>')
  --   map('n', '<leader>gp', '<cmd>Gitsigns preview_hunk<CR>')
  --   map('n', '<leader>gb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
  --   map('n', '<leader>gtb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
  --   map('n', '<leader>gd', '<cmd>Gitsigns diffthis<CR>')
  --   map('n', '<leader>gD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
  --   map('n', '<leader>gtd', '<cmd>Gitsigns toggle_deleted<CR>')

  --   -- Text object
  --   map('o', 'is', ':<C-U>Gitsigns select_hunk<CR>')
  --   map('x', 'is', ':<C-U>Gitsigns select_hunk<CR>')
  -- end

}
