local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    if autocmd[2].group and vim.fn.exists('#' .. autocmd[2].group) == 0 then
      vim.api.nvim_create_augroup(autocmd[2].group, { clear = true })
    end
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      group = 'YankHighlight',
      desc = 'Highlight the selection on yank.',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
      end,
    },
  },

  -- Append system clipboard to clipboard settings here because setting it on
  -- startup dramatically slows down startup time
  {
    { 'TextYankPost' },
    {
      group = 'YankToSystemClipboard',
      once = true,
      desc = 'Yank into system clipboard.',
      callback = function()
        vim.opt.clipboard:append('unnamedplus')
        vim.cmd('silent! let @+ = @' .. vim.v.register)
        return true
      end,
    },
  },

  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      pattern = '*',
      group = 'Autosave',
      desc = 'Autosave on focus change.',
      command = 'silent! wall',
      nested = true,
    },
  },

  {
    { 'WinEnter' },
    {
      pattern = '*',
      group = 'WinCloseJmp',
      desc = 'Jump to last accessed window on closing the current one.',
      callback = function()
        if '' ~= vim.api.nvim_win_get_config(0).relative then
          return
        end
        -- Record the window we jump from (previous) and to (current)
        if nil == vim.t.winid_rec then
          vim.t.winid_rec = {
            prev = vim.fn.win_getid(),
            current = vim.fn.win_getid(),
          }
        else
          vim.t.winid_rec = {
            prev = vim.t.winid_rec.current,
            current = vim.fn.win_getid(),
          }
        end
        -- Loop through all windows to check if the
        -- previous one has been closed
        for winnr = 1, vim.fn.winnr('$') do
          if vim.fn.win_getid(winnr) == vim.t.winid_rec.prev then
            return -- Return if previous window is not closed
          end
        end
        vim.cmd('wincmd p')
      end,
    },
  },

  {
    { 'BufReadPost' },
    {
      pattern = '*',
      group = 'LastPosJmp',
      desc = 'Last position jump.',
      callback = function(info)
        local ft = vim.bo[info.buf].ft
        -- don't apply to git messages
        if ft:match('commit') or ft:match('rebase') then
          return
        end
        -- get position of last saved edit
        local markpos = vim.api.nvim_buf_get_mark(0, '"')
        local line = markpos[1]
        local col = markpos[2]
        -- if in range, go there
        if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
          vim.api.nvim_win_set_cursor(0, { line, col })
          vim.cmd.normal({ 'zvzz', bang = true })
        end
      end,
    },
  },

  {
    { 'BufReadPost', 'BufWinEnter', 'WinEnter', 'FileChangedShellPost' },
    {
      pattern = '*',
      group = 'AutoCwd',
      desc = 'Automatically change local current directory.',
      callback = function(info)
        if info.file == '' or not vim.bo[info.buf].ma then
          return
        end
        local proj_dir = require('utils').fs.proj_dir(info.file)
        if proj_dir then
          vim.cmd.lcd(proj_dir)
        else
          local dirname = vim.fs.dirname(info.file)
          local stat = vim.uv.fs_stat(dirname)
          if stat and stat.type == 'directory' then
            vim.cmd.lcd(dirname)
          end
        end
      end,
    },
  },

  {
    { 'BufReadPre', 'UIEnter' },
    {
      group = 'RestoreBackground',
      once = true,
      desc = 'Restore dark/light background and colorscheme from ShaDa.',
      callback = function()
        if vim.g.theme_restored then
          return
        end
        vim.g.theme_restored = true
        if vim.g.BACKGROUND and vim.g.BACKGROUND ~= vim.go.background then
          vim.go.background = vim.g.BACKGROUND
        end
        if not vim.g.colors_name or vim.g.COLORSNAME ~= vim.g.colors_name then
          vim.cmd('silent! colorscheme ' .. (vim.g.COLORSNAME or 'nano'))
        end
        return true
      end,
    },
  },

  {
    { 'Signal' },
    {
      nested = true,
      pattern = 'SIGUSR1',
      group = 'SwitchBackground',
      desc = 'Change background on receiving signal SIGUSER1.',
      callback = function()
        local hrtime = vim.uv.hrtime()
        -- Check the last time when a signal is received/sent to avoid
        -- the infinite loop of
        -- -> receiving signal
        -- -> setting bg
        -- -> sending signals to other nvim instances
        -- -> receiving signals from other nvim instances
        -- -> setting bg
        -- -> ...
        if vim.g.sig_hrtime and hrtime - vim.g.sig_hrtime < 500000000 then
          return
        end
        vim.g.sig_hrtime = hrtime
        vim.cmd.rshada()
        -- Must save the background and colorscheme name read from ShaDa
        -- because setting background or colorscheme will overwrite them
        local background = vim.g.BACKGROUND or 'dark'
        local colors_name = vim.g.COLORSNAME or 'nano'
        if vim.go.background ~= background then
          vim.go.background = background
        end
        if vim.g.colors_name ~= colors_name then
          vim.cmd('silent! colorscheme ' .. colors_name)
        end
      end,
    },
  },
  {
    { 'Colorscheme' },
    {
      group = 'SwitchBackground',
      desc = 'Spawn setbg/setcolors on colorscheme change.',
      callback = function()
        vim.g.BACKGROUND = vim.go.background
        vim.g.COLORSNAME = vim.g.colors_name
        vim.cmd.wshada()
        local hrtime = vim.uv.hrtime()
        if vim.g.sig_hrtime and hrtime - vim.g.sig_hrtime < 500000000 then
          return
        end
        vim.g.sig_hrtime = hrtime
        local pid = vim.fn.getpid()
        if vim.fn.executable('setbg') == 1 then
          vim.uv.spawn('setbg', {
            args = {
              vim.go.background,
              '--exclude-nvim-processes=' .. pid,
            },
            stdio = { nil, nil, nil },
          })
        end
        if vim.fn.executable('setcolors') == 1 then
          vim.uv.spawn('setcolors', {
            args = {
              vim.g.colors_name,
              '--exclude-nvim-processes=' .. pid,
            },
            stdio = { nil, nil, nil },
          })
        end
      end,
    },
  },

  {
    { 'BufEnter' },
    {
      group = 'PromptBufKeymaps',
      desc = 'Undo automatic <C-w> remap in prompt buffers.',
      callback = function(info)
        if vim.bo[info.buf].buftype == 'prompt' then
          vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
        end
      end,
    },
  },

  {
    { 'TermOpen' },
    {
      group = 'TermOptions',
      desc = 'Terminal options.',
      callback = function(info)
        if vim.bo[info.buf].buftype == 'terminal' then
          vim.cmd.setlocal('nonu')
          vim.cmd.setlocal('nornu')
          vim.cmd.setlocal('statuscolumn=')
          vim.cmd.setlocal('signcolumn=no')
          vim.cmd.startinsert()
        end
      end,
    },
  },

  {
    { 'QuickFixCmdPost' },
    {
      group = 'QuickFixAutoOpen',
      desc = 'Open quickfix window if there are results.',
      callback = function(info)
        if vim.startswith(info.match, 'l') then
          vim.cmd('lwindow')
        else
          vim.cmd('botright cwindow')
        end
      end,
    },
  },

  {
    { 'VimResized' },
    {
      group = 'EqualWinSize',
      desc = 'Make window equal size on VimResized.',
      command = 'wincmd =',
    },
  },

  -- Show cursor line and cursor column only in current window
  {
    { 'WinEnter' },
    {
      once = true,
      group = 'AutoHlCursorLine',
      desc = 'Initialize cursorline winhl.',
      callback = function()
        local winlist = vim.api.nvim_list_wins()
        for _, win in ipairs(winlist) do
          vim.api.nvim_win_call(win, function()
            vim.opt_local.winhl:append({
              CursorLine = '',
              CursorColumn = '',
            })
          end)
        end
        return true
      end,
    },
  },
  {
    { 'BufWinEnter', 'WinEnter', 'InsertLeave' },
    {
      group = 'AutoHlCursorLine',
      callback = function()
        vim.defer_fn(function()
          if vim.fn.win_gettype() ~= '' then
            return
          end
          local winhl = vim.opt_local.winhl:get()
          -- Restore CursorLine and CursorColumn for current window
          -- if not in inert/replace/select mode
          if
            (winhl['CursorLine'] or winhl['CursorColumn'])
            and vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1
          then
            vim.opt_local.winhl:remove({
              'CursorLine',
              'CursorColumn',
            })
          end
          -- Conceal cursor line and cursor column in the previous window
          -- if current window is a normal window
          local current_win = vim.api.nvim_get_current_win()
          local prev_win = vim.fn.win_getid(vim.fn.winnr('#'))
          if
            prev_win ~= 0
            and prev_win ~= current_win
            and vim.api.nvim_win_is_valid(prev_win)
            and vim.fn.win_gettype(current_win) == ''
          then
            vim.api.nvim_win_call(prev_win, function()
              vim.opt_local.winhl:append({
                CursorLine = '',
                CursorColumn = '',
              })
            end)
          end
        end, 10)
      end,
    },
  },
  {
    { 'InsertEnter' },
    {
      group = 'AutoHlCursorLine',
      callback = function()
        vim.opt_local.winhl:append({
          CursorLine = '',
          CursorColumn = '',
        })
      end,
    },
  },

  {
    { 'BufWinEnter', 'BufEnter' },
    {
      group = 'UpdateFolds',
      desc = 'Update folds on BufEnter.',
      callback = function(info)
        if not vim.b[info.buf].foldupdated then
          vim.b[info.buf].foldupdated = true
          vim.cmd.normal('zx')
        end
      end,
    },
  },

  {
    { 'OptionSet' },
    {
      pattern = 'textwidth',
      group = 'TextwidthRelativeColorcolumn',
      desc = 'Set colorcolumn according to textwidth.',
      callback = function()
        if vim.v.option_new ~= '0' then
          vim.opt_local.colorcolumn = '+1'
        end
      end,
    },
  },

  {
    { 'OptionSet' },
    {
      pattern = 'diff',
      group = 'DisableWinBarInDiffMode',
      desc = 'Disable winbar in diff mode.',
      callback = function()
        if vim.v.option_new == '1' then
          vim.w._winbar = vim.wo.winbar
          vim.wo.winbar = nil
          if vim.wo.culopt:find('both') or vim.wo.culopt:find('line') then
            vim.w._culopt = vim.wo.culopt
            vim.wo.culopt = 'number'
          end
        else
          if vim.w._winbar then
            vim.wo.winbar = vim.w._winbar
            vim.w._winbar = nil
          end
          if vim.w._culopt then
            vim.wo.culopt = vim.w._culopt
            vim.w._culopt = nil
          end
        end
      end,
    },
  },

  {
    { 'ModeChanged', 'WinLeave', 'FocusLost' },
    {
      group = 'ClearMsgArea',
      desc = 'Automatically clear message area on specific events.',
      command = 'echo',
    },
  },

  {
    { 'BufWritePre' },
    {
      group = 'UpdateTimestamp',
      desc = 'Update timestamp automatically.',
      callback = function(info)
        if not vim.bo[info.buf].ma or not vim.bo[info.buf].mod then
          return
        end
        local lines = vim.api.nvim_buf_get_lines(info.buf, 0, 8, false)
        local update = false
        for idx, line in ipairs(lines) do
          -- Example: "Fri 07 Jul 2023 12:04:05 AM CDT"
          local new_str, pos = line:gsub(
            '%u%U%U%s+%d%d%s+%u%U%U%s+%d%d%d%d%s+%d%d:%d%d:%d%d%s+%u%u%s+%u+',
            os.date('%a %d %b %Y %I:%M:%S %p %Z')
          )
          if pos > 0 then
            update = true
            lines[idx] = new_str
          end
        end
        if update then
          vim.cmd.undojoin()
          vim.api.nvim_buf_set_lines(info.buf, 0, 8, false, lines)
        end
      end,
    },
  },

  {
    { 'CmdWinEnter' },
    {
      group = 'CmdWinRegexVimHl',
      desc = 'Use regex vim highlight in command window.',
      callback = function(info)
        if info.match == ':' then
          vim.cmd('silent! TSBufDisable highlight')
        end
      end,
    },
  },
}

set_autocmds(autocmds)
