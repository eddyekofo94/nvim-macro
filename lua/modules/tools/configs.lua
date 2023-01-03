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
  vim.keymap.set('n', '<Leader>fr', function() telescope_builtin.lsp_references({ jump_type = 'never', include_current_line = true }) end, keymap_opts)
  vim.keymap.set('n', '<Leader>fd', function() telescope_builtin.lsp_definitions({ jump_type = 'never', include_current_line = true }) end, keymap_opts)
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
        horizontal = { prompt_position = 'top', preview_width = 0.5 },
        vertical = { prompt_position = 'top', preview_width = 0.5 }
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
  vim.api.nvim_set_keymap('n', '<Leader>u', '<cmd>UndotreeToggle<CR>', { noremap = true })
end

M['vim-floaterm'] = function()
  vim.cmd([[
    let g:floaterm_width = 0.7
    let g:floaterm_height = 0.74
    let g:floaterm_opener = 'edit'

    function! s:get_bufnr_unnamed(buflist) abort
      for bufnr in a:buflist
        let name = getbufvar(bufnr, 'floaterm_name')
        if empty(name)
          return bufnr
        endif
      endfor
      return -1
    endfunction

    function! ToggleTool(tool, count) abort
      " If current buffer is a floaterm?
      let bufnr = bufnr('%')
      let buflist = floaterm#buflist#gather()
      if index(buflist, bufnr) == -1
        " find bufnr according to the tool name
        let bufnr = empty(a:tool) ?
          \ s:get_bufnr_unnamed(buflist) : floaterm#terminal#get_bufnr(a:tool)
      endif

      if bufnr == -1
        if empty(a:tool)
          " ToggleTool should only be called from
          " normal mode or terminal mode without bang
          call floaterm#run('new', 0, [visualmode(), 0, 0, 0], '')
        else
          call floaterm#run('new', 0, [visualmode(), 0, 0, 0],
            \ printf('--title=%s($1/$2) --name=%s %s', a:tool, a:tool, a:tool))
        endif
      else
        call floaterm#toggle(0, a:count ? a:count : bufnr, '')
        " workaround to prevent lazygit shift left;
        " another workaround here is to use sidlent!
        " to ignore can't re-enter normal mode error
        execute('silent! normal! 0')
      endif
    endfunction

    command! -nargs=? -count=0 -complete=customlist,floaterm#cmdline#complete_names1
        \ ToggleTool call ToggleTool(<q-args>, <count>)
    nnoremap <silent> <M-i> <Cmd>execute v:count . 'ToggleTool lazygit'<CR>
    nnoremap <silent> <C-\> <Cmd>execute v:count . 'ToggleTool'<CR>

    autocmd User FloatermOpen tnoremap <buffer> <silent> <M-i> <Cmd>execute v:count . 'ToggleTool lazygit'<CR>
    autocmd User FloatermOpen tnoremap <buffer> <silent> <C-\> <Cmd>execute v:count . 'ToggleTool'<CR>

    autocmd User FloatermOpen nnoremap <buffer> <silent> <S-Up> <Cmd>FloatermPrev<CR>
    autocmd User FloatermOpen tnoremap <buffer> <silent> <S-Up> <Cmd>FloatermPrev<CR>
    autocmd User FloatermOpen nnoremap <buffer> <silent> <S-Down> <Cmd>FloatermNext<CR>
    autocmd User FloatermOpen tnoremap <buffer> <silent> <S-Down> <Cmd>FloatermNext<CR>
  ]])
end

M['gitsigns.nvim'] = function()
  require('gitsigns').setup({
    signs = {
      add = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      untracked = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
      change = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
      changedelete = { hl = 'GitSignsDelete', text = '~', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
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
      map({ 'n', 'v' }, ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map({ 'n', 'v' }, '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map('n', '<leader>gs', gs.stage_hunk)
      map('n', '<leader>gr', gs.reset_hunk)
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

M['tmux.nvim'] = function()
  local tmux = require('tmux')
  tmux.setup({
    copy_sync = {
      enable = false,
    },
    navigation = {
      cycle_navigation = false,
      enable_default_keybindings = false,
    },
    resize = {
      enable_default_keybindings = false,
    },
  })

  vim.keymap.set('n', '<M-h>', tmux.move_left, { noremap = true })
  vim.keymap.set('n', '<M-j>', tmux.move_bottom, { noremap = true })
  vim.keymap.set('n', '<M-k>', tmux.move_top, { noremap = true })
  vim.keymap.set('n', '<M-l>', tmux.move_right, { noremap = true })
end

return M
