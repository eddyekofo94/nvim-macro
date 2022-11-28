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
  vim.keymap.set('n', '<Leader>fg', function() telescope_builtin.git_files() end, keymap_opts)
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
      border = 'single',
      width = function() return math.floor(0.7 * vim.o.columns) end,
      height = function() return math.floor(0.7 * vim.o.lines) end
    }
  })

  -- lazygit integration setup
  local Lazygit = nil

  local function lazygit_toggle()
    if Lazygit then
      Lazygit:toggle()
      return
    end
    local Terminal = require('toggleterm.terminal').Terminal
    local directory = require('toggleterm.utils').git_dir()
    if directory == nil then
      vim.notify('Git: Not in a git directory', vim.log.levels.WARN)
      return
    end
    if directory ~= vim.g.git_pred_dir then
      vim.g.git_pred_dir = directory
      Lazygit = Terminal:new({
        cmd = 'lazygit -p ' .. directory,
        hidden = true,
        -- function to run on opening the terminal
        on_open = function(term)
          local keymap_opts = {
            noremap = true,
            silent = true,
            buffer = term.bufnr
          }
          vim.keymap.set('n', 'q', '<cmd>close<CR>', keymap_opts)
          vim.keymap.set('n', '<esc>', '<cmd>close<CR>', keymap_opts)
          vim.keymap.set('n', '<M-C>', '<cmd>bd!<CR>', keymap_opts)
          vim.cmd('normal! 0')    -- workaround, else lazygit will shift left
          vim.cmd('startinsert')
        end
      })
    end
    Lazygit:toggle()
  end

  vim.keymap.set({ 'n', 't' }, '<M-i>',
      lazygit_toggle, { noremap = true, silent = true })
  vim.api.nvim_create_user_command('Lzgit', lazygit_toggle, {})
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

M['nvim-surround'] = function()
  require('nvim-surround').setup()
end

M['Comment.nvim'] = function()
  require('Comment').setup({
    ignore = '^$',
  })
end

M['nvim-autopairs'] = function()
  local npairs = require('nvim-autopairs')
  local Rule = require('nvim-autopairs.rule')

  npairs.setup({
    check_ts = true,
    fast_wrap = {
      map = '<C-c>',
      chars = { '{', '[', '(', '"', "'", '`' },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
      offset = 0, -- Offset from pattern match
      end_key = '$',
      keys = 'qwertyuiopzxcvbnmasdfghjkl',
      check_comma = true,
      highlight = 'Search',
      highlight_grey='Comment'
    }
  })

  npairs.add_rules({
    -- Add spaces between parenthesis
    Rule(' ', ' ')
      :with_pair(function (opts)
        local pair_single_char = opts.line:sub(opts.col - 1, opts.col)
        local pair_double_char = opts.line:sub(opts.col - 2, opts.col + 1)
        return vim.tbl_contains({ '()', '[]', '{}' }, pair_single_char) or
               vim.tbl_contains({ '/**/' }, pair_double_char)
       end)
      :with_del(function (opts)
        return vim.fn.match(opts.line:sub(1, opts.col):reverse(),
                            [[\s\((\|[\|{\|\*\/\)]]) == 0
      end),
    -- autopair c block comment
    Rule('/*', '*/', { 'c', 'cpp' }),
  })
end

return M
