local fzf = require('fzf-lua')
local actions = require('fzf-lua.actions')
local core = require('fzf-lua.core')
local path = require('fzf-lua.path')
local config = require('fzf-lua.config')
local utils = require('utils')

local _normalize_opts = config.normalize_opts

---Override `config.normalize_opts()` to always apply headers option,
---this eliminates the need to call `core.set_header()` in each provider
---@param opts table
---@return table: normalized opts
---@diagnostic disable-next-line: duplicate-set-field
function config.normalize_opts(opts, ...)
  opts = _normalize_opts(opts, ...)
  if opts.headers then
    opts = core.set_header(opts, opts.headers)
  end
  return opts
end

local _arg_del = actions.arg_del

---@diagnostic disable-next-line: duplicate-set-field
function actions.arg_del(...)
  pcall(_arg_del, ...)
end

---Switch provider while preserving the last query and cwd
---@return nil
function actions.switch_provider()
  local opts = {
    query = fzf.config.__resume_data.last_query,
    cwd = fzf.config.__resume_data.opts.cwd,
  }
  fzf.builtin({
    actions = {
      ['default'] = function(selected)
        fzf[selected[1]](opts)
      end,
      ['esc'] = actions.resume,
    },
  })
end

---Switch cwd while preserving the last query
---@return nil
function actions.switch_cwd()
  fzf.config.__resume_data.opts = fzf.config.__resume_data.opts or {}
  local opts = fzf.config.__resume_data.opts

  -- Remove old fn_selected, else selected item will be opened
  -- with previous cwd
  opts.fn_selected = nil
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.query = fzf.config.__resume_data.last_query

  vim.ui.input({
    prompt = 'New cwd: ',
    default = opts.cwd,
    completion = 'dir',
  }, function(input)
    if not input then
      return
    end
    input = vim.fs.normalize(input)
    local stat = vim.uv.fs_stat(input)
    if not stat or not stat.type == 'directory' then
      print('\n')
      vim.notify(
        '[Fzf-lua] invalid path: ' .. input .. '\n',
        vim.log.levels.ERROR
      )
      return
    end
    opts.cwd = input
  end)

  -- Adapted from fzf-lua `core.set_header()` function
  if opts.cwd_prompt then
    opts.prompt = vim.fn.fnamemodify(opts.cwd, ':.:~')
    local shorten_len = tonumber(opts.cwd_prompt_shorten_len)
    if shorten_len and #opts.prompt >= shorten_len then
      opts.prompt =
        path.shorten(opts.prompt, tonumber(opts.cwd_prompt_shorten_val) or 1)
    end
    if not path.ends_with_separator(opts.prompt) then
      opts.prompt = opts.prompt .. path.separator()
    end
  end

  if opts.headers then
    opts = core.set_header(opts, opts.headers)
  end

  actions.resume()
end

---Delete selected autocmd
---@return nil
function actions.del_autocmd(selected)
  for _, line in ipairs(selected) do
    local event, group, pattern =
      line:match('^.+:%d+:(%w+)%s*│%s*(%S+)%s*│%s*(.-)%s*│')
    if event and group and pattern then
      vim.cmd.autocmd({
        bang = true,
        args = { group, event, pattern },
        mods = { emsg_silent = true },
      })
    end
  end
  local last_query = fzf.config.__resume_data.last_query or ''
  fzf.autocmds({
    fzf_opts = {
      ['--query'] = vim.fn.shellescape(last_query),
    },
  })
end

---Search & select files then add them to arglist
---@return nil
function actions.arg_search_add()
  local opts = fzf.config.__resume_data.opts
  fzf.files({
    cwd_header = true,
    cwd_prompt = false,
    headers = { 'actions', 'cwd' },
    prompt = 'Argadd> ',
    actions = {
      ['default'] = function(selected, _opts)
        local cmd = 'argadd'
        vim.ui.input({
          prompt = 'Argadd cmd: ',
          default = cmd,
        }, function(input)
          if input then
            cmd = input
          end
        end)
        actions.vimcmd_file(cmd, selected, _opts)
        fzf.args(opts)
      end,
      ['esc'] = function()
        fzf.args(opts)
      end,
    },
    find_opts = [[-type f -type d -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type d --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  })
end

function actions._file_edit_or_qf(selected, opts)
  if #selected > 1 then
    actions.file_sel_to_qf(selected, opts)
    vim.cmd.cfirst()
    vim.cmd.copen()
  else
    actions.file_edit(selected, opts)
  end
end

function actions._file_sel_to_qf(selected, opts)
  actions.file_sel_to_qf(selected, opts)
  if #selected > 1 then
    vim.cmd.cfirst()
    vim.cmd.copen()
  end
end

function actions._file_set_to_ll(selected, opts)
  actions.file_sel_to_ll(selected, opts)
  if #selected > 1 then
    vim.cmd.lfirst()
    vim.cmd.lopen()
  end
end

-- core.ACTION_DEFINITIONS[actions.switch_provider] = { 'switch backend' }
-- core.ACTION_DEFINITIONS[actions.switch_cwd] = { 'change cwd' }
core.ACTION_DEFINITIONS[actions.arg_del] = { 'delete' }
core.ACTION_DEFINITIONS[actions.del_autocmd] = { 'delete autocmd' }
core.ACTION_DEFINITIONS[actions.arg_search_add] = { 'add new file' }
core.ACTION_DEFINITIONS[actions.search] = { 'edit' }
core.ACTION_DEFINITIONS[actions.ex_run] = { 'edit' }

-- stylua: ignore start
config._action_to_helpstr[actions.switch_provider] = 'switch-backend'
config._action_to_helpstr[actions.switch_cwd] = 'change-cwd'
config._action_to_helpstr[actions.arg_del] = 'delete'
config._action_to_helpstr[actions.del_autocmd] = 'delete-autocmd'
config._action_to_helpstr[actions.arg_search_add] = 'search-and-add-new-file'
config._action_to_helpstr[actions.buf_sel_to_qf] = 'buffer-select-to-quickfix'
config._action_to_helpstr[actions.buf_sel_to_ll] = 'buffer-select-to-loclist'
config._action_to_helpstr[actions._file_sel_to_qf] = 'file-select-to-quickfix'
config._action_to_helpstr[actions._file_set_to_ll] = 'file-select-to-loclist'
config._action_to_helpstr[actions._file_edit_or_qf] = 'file-edit-or-qf'
-- stylua: ignore end

fzf.setup({
  -- Use nbsp in tty to avoid showing box chars
  nbsp = not vim.g.modern_ui and '\xc2\xa0' or nil,
  winopts = {
    split = [[
        call v:lua.require'utils.win'.tabpage_saveview() |
        \ let g:_fzf_leave_win = win_getid(winnr()) |
        \ let wins = nvim_tabpage_list_wins(0) |
        \ let bot_win = -1 |
        \ let bot_win_type = '' |
        \ for winnr in range(len(wins), 1, -1) |
          \ let bot_win = win_getid(winnr) |
          \ let bot_win_type = win_gettype(bot_win) |
          \ if bot_win_type !=# 'popup' |
            \ break |
          \ endif |
        \ endfor |
        \ let g:_fzf_splitkeep = &splitkeep | let &splitkeep = "topline" |
        \ if bot_win_type =~# 'quickfix\|loclist' && bot_win != -1
            \ && nvim_win_get_width(bot_win) == &columns |
          \ let g:_fzf_swallow_qf_type = bot_win_type |
          \ let g:_fzf_swallow_qf_height = nvim_win_get_height(bot_win) |
          \ let g:_fzf_qf_cursor = nvim_win_get_cursor(bot_win) |
          \ call nvim_win_close(bot_win, v:false) |
        \ endif |
        \ let g:_fzf_cmdheight = &cmdheight | let &cmdheight = 0 |
        \ let g:_fzf_laststatus = &laststatus | let &laststatus = 0 |
        \ let height_delta = (g:_fzf_cmdheight - &cmdheight) +
          \ (g:_fzf_laststatus ? 1 : 0) |
        \ let fzf_height = (exists('g:_fzf_swallow_qf_height')
          \ ? g:_fzf_swallow_qf_height : 10) + height_delta |
        \ exe 'botright ' . fzf_height . ' new' |
        \ let w:winbar_no_attach = v:true |
        \ setlocal bt=nofile bh=wipe nobl noswf wfh |
        \ unlet wins bot_win bot_win_type height_delta fzf_height
    ]],
    on_create = function()
      local buf = vim.api.nvim_get_current_buf()
      -- Restore some terminal mode mappings (mapped in core.keymaps)
      -- to avoid conflicts with fzf-lua's action keymaps
      vim.keymap.set('t', '<M-s>', '<M-s>', { buffer = buf })
      vim.keymap.set('t', '<M-v>', '<M-v>', { buffer = buf })
      vim.keymap.set('t', '<M-o>', '<M-o>', { buffer = buf })
      vim.keymap.set('t', '<M-c>', '<M-c>', { buffer = buf })
      vim.keymap.set(
        't',
        '<C-r>',
        [['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
        { expr = true, buffer = buf }
      )
    end,
    on_close = function()
      ---@param name string
      ---@return nil
      local function _restore_global_opt(name)
        if vim.g['_fzf_' .. name] then
          vim.go[name] = vim.g['_fzf_' .. name]
          vim.g['_fzf_' .. name] = nil
        end
      end

      _restore_global_opt('splitkeep')
      _restore_global_opt('cmdheight')
      _restore_global_opt('laststatus')

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

      utils.win.tabpage_restview(0, true)

      if
        vim.g._fzf_leave_win
        and vim.api.nvim_win_is_valid(vim.g._fzf_leave_win)
        and vim.api.nvim_get_current_win() ~= vim.g._fzf_leave_win
      then
        vim.api.nvim_set_current_win(vim.g._fzf_leave_win)
      end
      vim.g._fzf_leave_win = nil
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
      ['alt-s'] = actions.file_split,
      ['alt-v'] = actions.file_vsplit,
      ['alt-t'] = actions.file_tabedit,
      ['alt-c'] = actions.switch_cwd,
      ['alt-q'] = actions._file_sel_to_qf,
      ['alt-o'] = actions._file_set_to_ll,
      ['default'] = actions._file_edit_or_qf,
    },
    buffers = {
      ['default'] = actions.buf_edit,
      ['alt-s'] = actions.buf_split,
      ['alt-v'] = actions.buf_vsplit,
      ['alt-t'] = actions.buf_tabedit,
    },
  },
  defaults = {
    headers = { 'actions' },
    actions = {
      ['ctrl-]'] = actions.switch_provider,
    },
  },
  args = {
    files_only = false,
    actions = {
      ['ctrl-s'] = actions.arg_search_add,
      ['ctrl-x'] = {
        fn = actions.arg_del,
        reload = true,
      },
    },
  },
  autocmds = {
    actions = {
      ['ctrl-x'] = {
        fn = actions.del_autocmd,
        -- reload = true,
      },
    },
  },
  blines = {
    actions = {
      ['alt-q'] = actions.buf_sel_to_qf,
      ['alt-o'] = actions.buf_sel_to_ll,
      ['alt-l'] = false,
    },
  },
  lines = {
    actions = {
      ['alt-q'] = actions.buf_sel_to_qf,
      ['alt-o'] = actions.buf_sel_to_ll,
      ['alt-l'] = false,
    },
  },
  buffers = {
    show_unlisted = true,
    show_unloaded = true,
    ignore_current_buffer = false,
    no_action_set_cursor = true,
    current_tab_only = false,
    no_term_buffers = false,
    cwd_only = false,
    ls_cmd = 'ls',
  },
  helptags = {
    actions = {
      ['default'] = actions.help,
      ['alt-s'] = actions.help,
      ['alt-v'] = actions.help_vert,
      ['alt-t'] = actions.help_tab,
    },
  },
  manpages = {
    actions = {
      ['default'] = actions.man,
      ['alt-s'] = actions.man,
      ['alt-v'] = actions.man_vert,
      ['alt-t'] = actions.man_tab,
    },
  },
  keymaps = {
    actions = {
      ['default'] = actions.keymap_apply,
      ['alt-s'] = actions.keymap_split,
      ['alt-v'] = actions.keymap_vsplit,
      ['alt-t'] = actions.keymap_tabedit,
    },
  },
  colorschemes = {
    actions = {
      ['default'] = actions.colorscheme,
    },
  },
  highlights = {
    actions = {
      ['default'] = function(selected)
        vim.defer_fn(function()
          vim.cmd.hi(selected[1])
        end, 0)
      end,
    },
  },
  command_history = {
    actions = {
      ['alt-e'] = actions.ex_run,
      ['ctrl-e'] = false,
    },
  },
  search_history = {
    actions = {
      ['alt-e'] = actions.search,
      ['ctrl-e'] = false,
    },
  },
  files = {
    fzf_opts = {
      ['--info'] = 'inline-right',
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
vim.keymap.set('n', '<Leader>?', fzf.help_tags)
vim.keymap.set('n', '<Leader>*', fzf.grep_cword)
vim.keymap.set('x', '<Leader>*', fzf.grep_visual)
vim.keymap.set('n', '<Leader>#', fzf.grep_cword)
vim.keymap.set('x', '<Leader>#', fzf.grep_visual)
vim.keymap.set('n', '<Leader>"', fzf.registers)
vim.keymap.set('n', '<Leader>F', fzf.builtin)
vim.keymap.set('n', '<Leader>o', fzf.oldfiles)
vim.keymap.set('n', '<Leader>-', fzf.blines)
vim.keymap.set('n', '<Leader>=', fzf.lines)
vim.keymap.set('n', '<Leader>s', fzf.lsp_document_symbols)
vim.keymap.set('n', '<Leader>S', fzf.lsp_live_workspace_symbols)
vim.keymap.set('n', '<Leader>f', fzf.builtin)
vim.keymap.set('n', '<Leader>f"', fzf.registers)
vim.keymap.set('n', '<Leader>f*', fzf.grep_cword)
vim.keymap.set('x', '<Leader>f*', fzf.grep_visual)
vim.keymap.set('n', '<Leader>f#', fzf.grep_cword)
vim.keymap.set('x', '<Leader>f#', fzf.grep_visual)
vim.keymap.set('n', '<Leader>f:', fzf.commands)
vim.keymap.set('n', '<Leader>f/', fzf.live_grep)
vim.keymap.set('n', '<Leader>fD', fzf.lsp_typedefs)
vim.keymap.set('n', '<Leader>fE', fzf.diagnostics_workspace)
vim.keymap.set('n', '<Leader>fH', fzf.highlights)
vim.keymap.set('n', "<Leader>f'", fzf.resume)
vim.keymap.set('n', '<Leader>fS', fzf.lsp_live_workspace_symbols)
vim.keymap.set('n', '<Leader>fA', fzf.autocmds)
vim.keymap.set('n', '<Leader>fb', fzf.buffers)
vim.keymap.set('n', '<Leader>fc', fzf.changes)
vim.keymap.set('n', '<Leader>fd', fzf.lsp_definitions)
vim.keymap.set('n', '<Leader>fe', fzf.diagnostics_document)
vim.keymap.set('n', '<Leader>ff', fzf.files)
vim.keymap.set('n', '<Leader>fa', fzf.args)
vim.keymap.set('n', '<Leader>fl', fzf.loclist)
vim.keymap.set('n', '<Leader>fq', fzf.quickfix)
vim.keymap.set('n', '<Leader>fL', fzf.loclist_stack)
vim.keymap.set('n', '<Leader>fQ', fzf.quickfix_stack)
vim.keymap.set('n', '<Leader>fgt', fzf.git_tags)
vim.keymap.set('n', '<Leader>fgs', fzf.git_stash)
vim.keymap.set('n', '<Leader>fgg', fzf.git_status)
vim.keymap.set('n', '<Leader>fgc', fzf.git_commits)
vim.keymap.set('n', '<Leader>fgl', fzf.git_bcommits)
vim.keymap.set('n', '<Leader>fgb', fzf.git_branches)
vim.keymap.set('n', '<Leader>fh', fzf.help_tags)
vim.keymap.set('n', '<Leader>f?', fzf.help_tags)
vim.keymap.set('n', '<Leader>fk', fzf.keymaps)
vim.keymap.set('n', '<Leader>f-', fzf.blines)
vim.keymap.set('n', '<Leader>f=', fzf.lines)
vim.keymap.set('n', '<Leader>fm', fzf.marks)
vim.keymap.set('n', '<Leader>fo', fzf.oldfiles)
vim.keymap.set('n', '<Leader>fr', fzf.lsp_references)
vim.keymap.set('n', '<Leader>fs', fzf.lsp_document_symbols)

vim.api.nvim_create_user_command('F', function(info)
  fzf.files({ cwd = info.fargs[1] })
end, {
  nargs = '?',
  complete = 'dir',
  desc = 'Fuzzy find files.',
})

local fzf_ls_cmd = {
  function(info)
    return fzf.buffers({
      ls_cmd = string.format('ls%s %s', info.bang and '!' or '', info.args),
    })
  end,
  {
    bang = true,
    nargs = '?',
    complete = function()
      return {
        '+',
        '-',
        '=',
        'a',
        'u',
        'h',
        'x',
        '%',
        '#',
        'R',
        'F',
        't',
      }
    end,
  },
}

local fzf_hi_cmd = {
  function(info)
    if vim.tbl_isempty(info.fargs) then
      fzf.highlights()
      return
    end
    if #info.fargs == 1 and info.fargs[1] ~= 'clear' then
      local hlgroup = info.fargs[1]
      if vim.fn.hlexists(hlgroup) == 1 then
        vim.cmd.hi({
          args = { hlgroup },
          bang = info.bang,
        })
      else
        fzf.highlights({
          fzf_opts = {
            ['--query'] = vim.fn.shellescape(hlgroup),
          },
        })
      end
      return
    end
    vim.cmd.hi({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = '*',
  },
}

local fzf_reg_cmd = {
  function(info)
    fzf.registers({
      fzf_opts = {
        ['--query'] = vim.fn.shellescape(
          table.concat(
            vim.tbl_map(
              function(reg)
                return string.format('^[%s]', reg:upper())
              end,
              vim.split(info.args, '', {
                trimempty = true,
              })
            ),
            ' | '
          )
        ),
      },
    })
  end,
  {
    nargs = '*',
  },
}

local fzf_au_cmd = {
  function(info)
    if #info.fargs <= 1 and not info.bang then
      fzf.autocmds({
        fzf_opts = {
          ['--query'] = vim.fn.shellescape(info.fargs[1] or ''),
        },
      })
      return
    end
    vim.cmd.autocmd({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = '*',
  },
}

local fzf_marks_cmd = {
  function(info)
    fzf.marks({
      fzf_opts = {
        ['--query'] = vim.fn.shellescape(
          table.concat(
            vim.tbl_map(
              function(mark)
                return '^' .. mark
              end,
              vim.split(info.args, '', {
                trimempty = true,
              })
            ),
            ' | '
          )
        ),
      },
    })
  end,
  {
    nargs = '*',
  },
}

local fzf_args_cmd = {
  function(info)
    if not info.bang and vim.tbl_isempty(info.fargs) then
      fzf.args()
      return
    end
    vim.cmd.args({
      args = info.fargs,
      bang = info.bang,
    })
  end,
  {
    bang = true,
    nargs = '*',
  },
}

local fzf_argadd_cmd = {
  function(info)
    if not vim.tbl_isempty(info.fargs) then
      vim.cmd.argadd({
        args = info.fargs,
        bang = info.bang,
        count = info.count,
      })
      return
    end

    fzf.files({
      cwd_header = true,
      cwd_prompt = false,
      headers = { 'actions', 'cwd' },
      prompt = 'Argadd> ',
      actions = {
        ['default'] = function(selected, _opts)
          actions.vimcmd_file(
            (info.line1 == info.line2 and info.line1 or '') .. 'argadd',
            selected,
            _opts
          )
        end,
      },
      find_opts = [[-type f -type d -type l -not -path '*/\.git/*' -printf '%P\n']],
      fd_opts = [[--color=never --type f --type d --type l --hidden --follow --exclude .git]],
      rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
    })
  end,
  {
    count = true,
    nargs = '*',
    complete = 'file',
  },
}

local fzf_argdel_cmd = {
  function(info)
    if not vim.tbl_isempty(info.fargs) then
      vim.cmd.argdelete({
        args = info.fargs,
        bang = info.bang,
        count = info.count,
      })
      return
    end
    fzf.args({
      cwd_prompt = false,
      headers = { 'actions' },
      prompt = 'Argdelete> ',
      actions = {
        ['ctrl-s'] = false,
        ['ctrl-x'] = false,
        ['enter'] = actions.arg_del,
      },
    })
  end,
  {
    count = true,
    nargs = '*',
    complete = 'arglist',
  },
}

-- stylua: ignore start
vim.api.nvim_create_user_command('Ls', unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command('Files', unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command('Args', unpack(fzf_args_cmd))
vim.api.nvim_create_user_command('Autocmd', unpack(fzf_au_cmd))
vim.api.nvim_create_user_command('Buffers', unpack(fzf_ls_cmd))
vim.api.nvim_create_user_command('Marks', unpack(fzf_marks_cmd))
vim.api.nvim_create_user_command('Highlight', unpack(fzf_hi_cmd))
vim.api.nvim_create_user_command('Argadd', unpack(fzf_argadd_cmd))
vim.api.nvim_create_user_command('Argdelete', unpack(fzf_argdel_cmd))
vim.api.nvim_create_user_command('Registers', unpack(fzf_reg_cmd))
vim.api.nvim_create_user_command('Oldfiles', fzf.oldfiles, {})
vim.api.nvim_create_user_command('Changes', fzf.changes, {})
vim.api.nvim_create_user_command('Tags', fzf.tagstack, {})
vim.api.nvim_create_user_command('Jumps', fzf.jumps, {})
vim.api.nvim_create_user_command('Tabs', fzf.tabs, {})
-- stylua: ignore end

---Set telescope default hlgroups for a borderless view
---@return nil
local function set_default_hlgroups()
  local hl = utils.hl
  local hl_norm = hl.get(0, { name = 'Normal', link = false })
  local hl_speical = hl.get(0, { name = 'Special', link = false })
  hl.set(0, 'FzfLuaBufFlagAlt', {})
  hl.set(0, 'FzfLuaBufFlagCur', {})
  hl.set(0, 'FzfLuaBufName', {})
  hl.set(0, 'FzfLuaBufNr', {})
  hl.set(0, 'FzfLuaBufLineNr', { link = 'LineNr' })
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
