local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    if autocmd[2].group and vim.fn.exists('#' .. autocmd[2].group) == 0 then
      vim.api.nvim_create_augroup(autocmd[2].group, { clear = true })
    end
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  -- Highlight the selection on yank
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      group = 'YankHighlight',
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
      callback = function()
        vim.opt.clipboard:append('unnamedplus')
        vim.cmd('silent! let @+ = @' .. vim.v.register)
      end,
      once = true,
    },
  },

  -- Autosave on focus change
  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      pattern = '*',
      group = 'Autosave',
      command = 'silent! wall',
      nested = true,
    },
  },

  -- Jump to last accessed window on closing the current one
  {
    { 'WinEnter' },
    {
      pattern = '*',
      group = 'WinCloseJmp',
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

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      group = 'LastPosJmp',
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

  -- Automatically change local current directory
  {
    { 'WinEnter', 'BufWinEnter' },
    {
      pattern = '*',
      group = 'AutoCwd',
      callback = function(info)
        if info.file == '' or not vim.bo[info.buf].ma then
          return
        end

        ---Compute project directory for given path.
        ---@param fpath string
        ---@return string|nil
        local function find_proj_dir(fpath)
          if not fpath or fpath == '' then
            return nil
          end
          local root_patterns = {
            '.git',
            '.svn',
            '.bzr',
            '.hg',
            '.project',
            '.pro',
            '.sln',
            '.vcxproj',
            '.editorconfig',
          }
          local dirpath = vim.fs.dirname(fpath)
          local root = vim.fs.find(root_patterns, {
            path = dirpath,
            upward = true,
          })[1]
          if root and vim.loop.fs_stat(root) then
            return vim.fs.dirname(root)
          end
          if dirpath then
            local dirstat = vim.loop.fs_stat(dirpath)
            if dirstat and dirstat.type == 'directory' then
              return dirpath
            end
          end
          return nil
        end

        local proj_dir = find_proj_dir(info.file)
        if proj_dir then
          vim.cmd.tcd(proj_dir)
        end
      end,
    },
  },

  -- Restore dark/light background from ShaDa
  {
    { 'BufReadPre', 'UIEnter' },
    {
      group = 'RestoreBackground',
      callback = function()
        if
          not vim.g.background_restored
          and vim.g.BACKGROUND
          and vim.g.BACKGROUND ~= vim.go.background
        then
          vim.g.background_restored = true
          vim.go.background = vim.g.BACKGROUND
        end
      end,
      once = true,
    },
  },

  -- Undo automatic <C-w> remap in prompt buffers
  {
    { 'BufEnter' },
    {
      group = 'PromptBufKeymaps',
      callback = function(info)
        if vim.bo[info.buf].buftype == 'prompt' then
          vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
        end
      end,
    },
  },

  -- Terminal options
  {
    { 'TermOpen' },
    {
      group = 'TermOptions',
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

  -- Open quickfix window if there are results
  {
    { 'QuickFixCmdPost' },
    {
      group = 'QuickFixAutoOpen',
      callback = function(info)
        if vim.startswith(info.match, 'l') then
          vim.cmd.lwindow()
        else
          vim.cmd.cwindow()
        end
      end,
    },
  },

  -- Make window equal size on VimResized
  {
    { 'VimResized' },
    {
      group = 'EqualWinSize',
      command = 'wincmd =',
    },
  },

  -- Show cursor line and cursor column only in current window
  {
    { 'WinEnter' },
    {
      once = true,
      group = 'AutoHlCursorLine',
      callback = function()
        local winlist = vim.api.nvim_list_wins()
        for _, win in ipairs(winlist) do
          -- stylua: ignore start
          local new_winhl = (vim.wo[win].winhl
            :gsub('CursorLine:[^,]*', '')
            :gsub('CursorColumn:[^,]*', '')
              .. ',CursorLine:' .. ',CursorColumn:')
            :gsub('^,*', ''):gsub(',*$', ''):gsub(',+', ',')
          -- stylua: ignore end
          if new_winhl ~= vim.wo[win].winhl then
            vim.wo[win].winhl = new_winhl
          end
        end
      end,
    },
  },
  {
    { 'BufWinEnter', 'WinEnter', 'InsertLeave' },
    {
      group = 'AutoHlCursorLine',
      callback = function()
        vim.defer_fn(function()
          local winhl = vim.opt_local.winhl:get()
          if
            (winhl['CursorLine'] or winhl['CursorColumn'])
            and not vim.wo.diff
            and vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1
          then
            vim.opt_local.winhl:remove({
              'CursorLine',
              'CursorColumn',
            })
          end
        end, 10)
      end,
    },
  },
  {
    { 'WinLeave', 'InsertEnter' },
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

  -- Update folds on BufEnter
  {
    { 'BufWinEnter', 'BufEnter' },
    {
      group = 'UpdateFolds',
      callback = function(info)
        if not vim.b[info.buf].foldupdated then
          vim.b[info.buf].foldupdated = true
          vim.cmd.normal('zx')
        end
      end,
    },
  },

  -- Smart expandtab: use tabs for indentation and spaces for alignment
  {
    { 'InsertEnter', 'CursorMovedI' },
    {
      group = 'SmartExpandtab',
      callback = function(info)
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local after_non_blank = vim.fn.match(line:sub(1, col), [[\S]]) >= 0
        -- An adjacent tab is a tab that can be joined with the tab
        -- inserted before the cursor assuming 'noet' is set
        local has_adjacent_tabs = vim.fn.match(
          line:sub(1, col),
          string.format([[\t\ \{,%d}$]], math.max(0, vim.bo[info.buf].ts - 1))
        ) >= 0 or line:sub(col + 1, col + 1) == '\t'
        if after_non_blank and not has_adjacent_tabs then
          if vim.b[info.buf].expandtab == nil then
            vim.b[info.buf].expandtab = vim.bo.expandtab
          end
          vim.bo[info.buf].expandtab = true
        elseif vim.b[info.buf].expandtab ~= nil then
          vim.bo[info.buf].expandtab = vim.b[info.buf].expandtab
          vim.b[info.buf].expandtab = nil
        end
      end,
    },
  },
  {
    { 'InsertLeave' },
    {
      group = 'SmartExpandtab',
      callback = function(info)
        -- Restore expandtab setting
        if vim.b[info.buf].expandtab ~= nil then
          vim.bo[info.buf].expandtab = vim.b[info.buf].expandtab
          vim.b[info.buf].expandtab = nil
        end
      end,
    },
  },

  -- Set colorcolumn according to textwidth
  {
    { 'OptionSet' },
    {
      pattern = 'textwidth',
      callback = function()
        if vim.v.option_new ~= '0' then
          vim.opt_local.colorcolumn = '+1'
        else
          vim.opt_local.colorcolumn = vim.go.colorcolumn
        end
      end,
    },
  },
}

set_autocmds(autocmds)
