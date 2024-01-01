local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')
local utils = require('utils')

---Switch provider while preserving the last query and cwd
---@return nil
local function switch_provider()
  local opts = {
    query = fzf.config.__resume_data.last_query,
    cwd = fzf.config.__resume_data.opts.cwd,
  }
  fzf.builtin({
    actions = {
      ['default'] = function(selected)
        fzf[selected[1]](opts)
      end,
    },
  })
end

fzf.setup({
  -- Use nbsp in tty to avoid showing box chars
  nbsp = not vim.g.modern_ui and '\xc2\xa0' or nil,
  winopts = {
    split = [[
      let g:_fzf_splitkeep = &splitkeep |
        \ let &splitkeep = "topline" |
        \ let g:_fzf_leave_win = win_getid(winnr()) |
        \ let g:_fzf_leave_win_view = winsaveview() |
        \ let last_win = win_getid(winnr('$')) |
        \ let last_win_type = win_gettype(last_win) |
        \ if last_win_type =~# 'quickfix\|loclist'
            \ && nvim_win_get_width(last_win) == &columns |
          \ let g:_fzf_swallow_qf_type = last_win_type |
          \ let g:_fzf_swallow_qf_height = nvim_win_get_height(last_win) |
          \ let g:_fzf_qf_cursor = nvim_win_get_cursor(last_win) |
          \ call nvim_win_close(last_win, v:false) |
          \ unlet last_win last_win_type |
        \ endif |
        \ bo new |
        \ let w:winbar_no_attach = v:true |
        \ exe 'resize ' . (exists('g:_fzf_swallow_qf_height')
          \ ? g:_fzf_swallow_qf_height : 10) |
        \ setlocal winfixheight
    ]],
    on_create = function()
      local buf = vim.api.nvim_get_current_buf()
      -- Restore '<M-s>' and '<M-v>' in terminal mode mappings
      -- They are originally mapped to split current window in core.keymaps,
      -- which conflicts with fzf-lua's split keymaps
      vim.keymap.set('t', '<M-s>', '<M-s>', { buffer = buf })
      vim.keymap.set('t', '<M-v>', '<M-v>', { buffer = buf })
      vim.keymap.set('t', '<M-l>', '<M-l>', { buffer = buf })
      vim.keymap.set('t', '<M-o>', '<Nop>', { buffer = buf })
      vim.keymap.set(
        't',
        '<C-r>',
        [['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
        { expr = true, buffer = buf }
      )
    end,
    on_close = function()
      if vim.g._fzf_splitkeep then
        vim.go.splitkeep = vim.g._fzf_splitkeep
        vim.g._fzf_splitkeep = nil
      end

      if vim.g._fzf_swallow_qf_type and vim.g._fzf_qf_cursor then
        local cur_win = vim.api.nvim_get_current_win()
        local cur_win_view = vim.fn.winsaveview()
        vim.cmd({
          cmd = vim.g._fzf_swallow_qf_type == 'quickfix' and 'copen'
            or 'lopen',
          mods = { split = 'botright' },
          count = vim.g._fzf_swallow_qf_height,
        })
        vim.api.nvim_win_set_cursor(0, vim.g._fzf_qf_cursor)
        vim.api.nvim_win_call(cur_win, function()
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.fn.winrestview(cur_win_view)
        end)
      end
      vim.g._fzf_swallow_qf_height = nil
      vim.g._fzf_swallow_qf_type = nil
      vim.g._fzf_qf_cursor = nil

      if
        vim.g._fzf_leave_win
        and vim.g._fzf_leave_win_view
        and vim.api.nvim_win_is_valid(vim.g._fzf_leave_win)
      then
        vim.api.nvim_set_current_win(vim.g._fzf_leave_win)
        vim.fn.winrestview(vim.g._fzf_leave_win_view)
      end
      vim.g._fzf_leave_win = nil
      vim.g._fzf_leave_win_view = nil
    end,
    preview = {
      hidden = 'hidden',
    },
  },
  hls = {
    normal = 'TelescopeNormal',
    border = 'TelescopeBorder',
    title = 'TelescopeTitle',
    help_normal = 'TelescopeNormal',
    help_border = 'TelescopeBorder',
    preview_normal = 'TelescopeNormal',
    preview_border = 'TelescopeBorder',
    preview_title = 'TelescopeTitle',
    -- Builtin preview only
    cursor = 'Cursor',
    cursorline = 'TelescopePreviewLine',
    cursorlinenr = 'TelescopePreviewLine',
    search = 'IncSearch',
  },
  fzf_colors = {
    ['fg'] = { 'fg', 'TelescopeNormal' },
    ['bg'] = { 'bg', 'TelescopeNormal' },
    ['hl'] = { 'fg', 'TelescopeMatching' },
    ['fg+'] = { 'fg', 'TelescopeSelection' },
    ['bg+'] = { 'bg', 'TelescopeSelection' },
    ['hl+'] = { 'fg', 'TelescopeMatching' },
    ['info'] = { 'fg', 'TelescopeCounter' },
    ['border'] = { 'fg', 'TelescopeBorder' },
    ['gutter'] = { 'bg', 'TelescopeNormal' },
    ['prompt'] = { 'fg', 'TelescopePrefix' },
    ['pointer'] = { 'fg', 'TelescopeSelectionCaret' },
    ['marker'] = { 'fg', 'TelescopeMultiIcon' },
  },
  keymap = {
    -- Overrides default completion completely
    builtin = {
      ['<F1>'] = 'toggle-help',
      ['<F2>'] = 'toggle-fullscreen',
    },
    fzf = {
      -- fzf '--bind=' options
      ['ctrl-z'] = 'abort',
      ['ctrl-k'] = 'kill-line',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['alt-a'] = 'toggle-all',
      ['alt-}'] = 'last',
      ['alt-{'] = 'first',
    },
  },
  actions = {
    files = {
      ['default'] = function(selected, opts)
        if #selected > 1 then
          actions.file_sel_to_qf(selected, opts)
          vim.cmd.cfirst()
          vim.cmd.copen()
        else
          actions.file_edit(selected, opts)
        end
      end,
      ['alt-s'] = actions.file_split,
      ['alt-v'] = actions.file_vsplit,
      ['alt-t'] = actions.file_tabedit,
      ['alt-q'] = function(selected, opts)
        actions.file_sel_to_qf(selected, opts)
        if #selected > 1 then
          vim.cmd.cfirst()
          vim.cmd.copen()
        end
      end,
      ['alt-l'] = function(selected, opts)
        actions.file_sel_to_ll(selected, opts)
        if #selected > 1 then
          vim.cmd.lfirst()
          vim.cmd.lopen()
        end
      end,
      ['ctrl-_'] = switch_provider,
    },
    buffers = {
      ['default'] = actions.buf_edit,
      ['alt-s'] = actions.buf_split,
      ['alt-v'] = actions.buf_vsplit,
      ['alt-t'] = actions.buf_tabedit,
      ['ctrl-_'] = switch_provider,
    },
  },
  helptags = {
    actions = {
      ['default'] = actions.help,
      ['alt-s'] = actions.help,
      ['alt-v'] = actions.help_vert,
      ['alt-t'] = actions.help_tab,
      ['ctrl-_'] = switch_provider,
    },
  },
  manpages = {
    actions = {
      ['default'] = actions.man,
      ['alt-s'] = actions.man,
      ['alt-v'] = actions.man_vert,
      ['alt-t'] = actions.man_tab,
      ['ctrl-_'] = switch_provider,
    },
  },
  keymaps = {
    actions = {
      ['default'] = actions.keymap_apply,
      ['alt-s'] = actions.keymap_split,
      ['alt-v'] = actions.keymap_vsplit,
      ['alt-t'] = actions.keymap_tabedit,
      ['ctrl-_'] = switch_provider,
    },
  },
  code_actions = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  quickfix_stack = {
    actions = {
      ['default'] = actions.set_qflist,
      ['ctrl-_'] = switch_provider,
    },
  },
  loclist_stack = {
    actions = {
      ['default'] = actions.set_qflist,
      ['ctrl-_'] = switch_provider,
    },
  },
  colorschemes = {
    actions = {
      ['default'] = actions.colorscheme,
      ['ctrl-_'] = switch_provider,
    },
  },
  highlights = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  builtin = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  profiles = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  marks = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  jumps = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  commands = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  command_history = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  search_history = {
    actions = {
      ['default'] = actions.search_cr,
      ['ctrl-e'] = actions.search,
      ['ctrl-_'] = switch_provider,
    },
  },
  registers = {
    actions = {
      ['default'] = actions.paste_register,
      ['ctrl-_'] = switch_provider,
    },
  },
  spell_suggest = {
    actions = {
      ['default'] = actions.spell_apply,
      ['ctrl-_'] = switch_provider,
    },
  },
  filetypes = {
    actions = {
      ['default'] = actions.set_filetype,
      ['ctrl-_'] = switch_provider,
    },
  },
  packadd = {
    actions = {
      ['default'] = actions.packadd,
      ['ctrl-_'] = switch_provider,
    },
  },
  menus = {
    actions = {
      ['default'] = actions.exec_menu,
      ['ctrl-_'] = switch_provider,
    },
  },
  tmux = {
    buffers = {
      actions = {
        ['default'] = actions.tmux_buf_set_reg,
        ['ctrl-_'] = switch_provider,
      },
    },
  },
  dap = {
    commands = { ['ctrl-_'] = switch_provider },
    configurations = { ['ctrl-_'] = switch_provider },
    variables = { ['ctrl-_'] = switch_provider },
    frames = { ['ctrl-_'] = switch_provider },
  },
  complete_path = {
    actions = {
      ['default'] = actions.complete,
      ['ctrl-_'] = switch_provider,
    },
  },
  complete_line = {
    actions = {
      ['ctrl-_'] = switch_provider,
    },
  },
  fzf_opts = {
    ['--no-scrollbar'] = '',
    ['--no-separator'] = '',
    ['--info'] = 'inline-right',
    ['--layout'] = 'reverse',
    ['--marker'] = '+',
    ['--pointer'] = '→',
    ['--prompt'] = '/ ',
    ['--border'] = 'none',
    ['--padding'] = '0,1',
    ['--margin'] = '0',
    ['--no-preview'] = '',
    ['--preview-window'] = 'hidden',
  },
  files = {
    fzf_opts = {
      ['--info'] = 'inline-right',
    },
  },
  grep = {
    rg_opts = table.concat({
      '--hidden',
      '--follow',
      '--smart-case',
      '--column',
      '--line-number',
      '--no-heading',
      '--color=always',
      '-g=!.git/',
      '-e',
    }, ' '),
    fzf_opts = {
      ['--info'] = 'inline-right',
    },
  },
  lsp = {
    finder = {
      fzf_opts = {
        ['--info'] = 'inline-right',
      },
    },
    symbols = {
      symbol_icons = vim.tbl_map(vim.trim, utils.static.icons.kinds),
    },
  },
})

vim.keymap.set('n', '<Leader>.', fzf.files)
vim.keymap.set('n', "<Leader>'", fzf.resume)
vim.keymap.set('n', '<Leader>,', fzf.buffers)
vim.keymap.set('n', '<Leader>/', fzf.live_grep)
vim.keymap.set('n', '<Leader>?', fzf.live_grep)
vim.keymap.set('n', '<Leader>*', fzf.grep_cword)
vim.keymap.set('x', '<Leader>*', fzf.grep_visual)
vim.keymap.set('n', '<Leader>#', fzf.grep_cword)
vim.keymap.set('x', '<Leader>#', fzf.grep_visual)
vim.keymap.set('n', '<Leader>"', fzf.registers)
vim.keymap.set('n', '<Leader>F', fzf.builtin)
vim.keymap.set('n', '<Leader>o', fzf.oldfiles)
vim.keymap.set('n', '<Leader>s', fzf.lsp_document_symbols)
vim.keymap.set('n', '<Leader>S', fzf.lsp_live_workspace_symbols)
vim.keymap.set('n', '<Leader>q:', fzf.command_history)
vim.keymap.set('n', '<Leader>q/', fzf.command_history)
vim.keymap.set('n', '<Leader>f"', fzf.registers)
vim.keymap.set('n', '<Leader>f', fzf.builtin)
vim.keymap.set('n', '<Leader>f*', fzf.grep_cword)
vim.keymap.set('x', '<Leader>f*', fzf.grep_visual)
vim.keymap.set('n', '<Leader>f#', fzf.grep_cword)
vim.keymap.set('x', '<Leader>f#', fzf.grep_visual)
vim.keymap.set('n', '<Leader>f:', fzf.commands)
vim.keymap.set('n', '<Leader>f/', fzf.live_grep)
vim.keymap.set('n', '<Leader>f?', fzf.live_grep)
vim.keymap.set('n', '<Leader>fD', fzf.lsp_typedefs)
vim.keymap.set('n', '<Leader>fE', fzf.diagnostics_workspace)
vim.keymap.set('n', '<Leader>fH', fzf.highlights)
vim.keymap.set('n', "<Leader>f'", fzf.resume)
vim.keymap.set('n', '<Leader>fS', fzf.lsp_live_workspace_symbols)
vim.keymap.set('n', '<Leader>fa', fzf.autocmds)
vim.keymap.set('n', '<Leader>fb', fzf.buffers)
vim.keymap.set('n', '<Leader>fc', fzf.changes)
vim.keymap.set('n', '<Leader>fd', fzf.lsp_definitions)
vim.keymap.set('n', '<Leader>fe', fzf.diagnostics_document)
vim.keymap.set('n', '<Leader>ff', fzf.files)
vim.keymap.set('n', '<Leader>fg', fzf.git_status)
vim.keymap.set('n', '<Leader>fG', fzf.git_commits)
vim.keymap.set('n', '<Leader>fh', fzf.help_tags)
vim.keymap.set('n', '<Leader>fk', fzf.keymaps)
vim.keymap.set('n', '<Leader>fl', fzf.blines)
vim.keymap.set('n', '<Leader>fL', fzf.lines)
vim.keymap.set('n', '<Leader>fm', fzf.marks)
vim.keymap.set('n', '<Leader>fo', fzf.oldfiles)
vim.keymap.set('n', '<Leader>fq/', fzf.search_history)
vim.keymap.set('n', '<Leader>fq:', fzf.command_history)
vim.keymap.set('n', '<Leader>fq?', fzf.command_history)
vim.keymap.set('n', '<Leader>fr', fzf.lsp_references)
vim.keymap.set('n', '<Leader>fs', fzf.lsp_document_symbols)

-- Mimic fzf.vim's :FZF command
local fzf_cmd_body = {
  function(info)
    fzf.files({ cwd = info.fargs[1] })
  end,
  {
    nargs = '?',
    complete = 'dir',
    desc = 'Fuzzy find files.',
  },
}
vim.api.nvim_create_user_command('F', unpack(fzf_cmd_body))
vim.api.nvim_create_user_command('FZ', unpack(fzf_cmd_body))
vim.api.nvim_create_user_command('FZF', unpack(fzf_cmd_body))

---Set telescope default hlgroups for a borderless view
---@return nil
local function set_default_hlgroups()
  local hl = utils.hl
  local hl_norm = hl.get(0, { name = 'Normal', link = false })
  local hl_speical = hl.get(0, { name = 'Special', link = false })
  hl.set(0, 'FzfLuaBufFlagAlt', { link = 'CursorLineNr' })
  hl.set(0, 'FzfLuaBufFlagCur', { link = 'CursorLineNr' })
  hl.set(0, 'FzfLuaBufLineNr', { link = 'LineNr' })
  hl.set(0, 'FzfLuaBufName', { link = 'Directory' })
  hl.set(0, 'FzfLuaBufNr', { link = 'LineNr' })
  hl.set(0, 'FzfLuaCursor', { link = 'None' })
  hl.set(0, 'FzfLuaHeaderBind', { link = 'Special' })
  hl.set(0, 'FzfLuaHeaderText', { link = 'Special' })
  hl.set(0, 'FzfLuaTabMarker', { link = 'Keyword' })
  hl.set(0, 'FzfLuaTabTitle', { link = 'Title' })
  hl.set(0, 'TelescopeNormal', { link = 'Normal' })
  hl.set_default(0, 'TelescopeBorder', { link = 'TelescopeNormal' })
  hl.set_default(0, 'TelescopeSelection', { link = 'Visual' })
  hl.set_default(0, 'TelescopePrefix', { link = 'Operator' })
  hl.set_default(0, 'TelescopeCounter', { link = 'LineNr' })
  hl.set_default(0, 'TelescopeTitle', {
    fg = hl_norm.bg,
    bg = hl_speical.fg,
    bold = true,
  })
end

set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('FzfLuaSetDefaultHlgroups', {}),
  desc = 'Set default hlgroups for fzf-lua.',
  callback = set_default_hlgroups,
})
