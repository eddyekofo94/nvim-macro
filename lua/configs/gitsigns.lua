local icons = require('utils').static.icons

require('gitsigns').setup({
  preview_config = {
    border = 'solid',
    style = 'minimal',
  },
  signs = {
    add = { text = vim.trim(icons.GitSignAdd) },
    untracked = { text = vim.trim(icons.GitSignUntracked) },
    change = { text = vim.trim(icons.GitSignChange) },
    delete = { text = vim.trim(icons.GitSignDelete) },
    topdelete = { text = vim.trim(icons.GitSignTopdelete) },
    changedelete = { text = vim.trim(icons.GitSignChangedelete) },
  },
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 100,
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map({ 'n', 'x' }, ']c', function()
      if vim.wo.diff then
        vim.api.nvim_feedkeys(vim.v.count1 .. ']c', 'n', true)
        return
      end
      for _ = 1, vim.v.count1 do
        gs.next_hunk()
      end
    end)

    map({ 'n', 'x' }, '[c', function()
      if vim.wo.diff then
        vim.api.nvim_feedkeys(vim.v.count1 .. '[c', 'n', true)
        return
      end
      for _ = 1, vim.v.count1 do
        gs.prev_hunk()
      end
    end)

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk)
    map('n', '<leader>gr', gs.reset_hunk)
    map('n', '<leader>gS', gs.stage_buffer)
    map('n', '<leader>gu', gs.undo_stage_hunk)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', gs.blame_line)

    map('x', '<leader>gs', function()
      gs.stage_hunk({
        vim.fn.line('.'),
        vim.fn.line('v'),
      })
    end)
    map('x', '<leader>gr', function()
      gs.reset_hunk({
        vim.fn.line('.'),
        vim.fn.line('v'),
      })
    end)

    -- Text object
    map(
      { 'o', 'x' },
      'ic',
      ':<C-U>Gitsigns select_hunk<CR>',
      { silent = true }
    )
    map(
      { 'o', 'x' },
      'ac',
      ':<C-U>Gitsigns select_hunk<CR>',
      { silent = true }
    )
  end,
})
