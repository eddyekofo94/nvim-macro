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
      callback = function(tbl)
        local ft = vim.bo[tbl.buf].ft
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
      callback = function(tbl)
        if tbl.file == '' or not vim.bo[tbl.buf].ma then
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

        local proj_dir = find_proj_dir(tbl.file)
        if proj_dir then
          vim.cmd.tcd(proj_dir)
        end
      end,
    },
  },

  -- Automatically create missing directories
  {
    { 'BufWritePre' },
    {
      pattern = '*',
      group = 'AutoMkdir',
      callback = function()
        vim.fn.mkdir(vim.fn.expand('%:p:h'), 'p')
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
      callback = function(tbl)
        if vim.bo[tbl.buf].buftype == 'prompt' then
          vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = tbl.buf })
        end
      end,
    },
  },

  -- Terminal options
  {
    { 'TermOpen' },
    {
      group = 'TermOptions',
      callback = function(tbl)
        if vim.bo[tbl.buf].buftype == 'terminal' then
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
    { 'ModeChanged' },
    {
      group = 'TermOptions',
      pattern = { '*:t', 't:*' },
      callback = function(tbl)
        if vim.fn.match(tbl.match, '.*:t$') ~= -1 then
          vim.cmd.setlocal('matchpairs=')
        else
          vim.cmd.setlocal('matchpairs&')
        end
      end
    }
  },

  -- Open quickfix window if there are results
  {
    { 'QuickFixCmdPost' },
    {
      group = 'QuickFixAutoOpen',
      callback = function(tbl)
        if vim.startswith(tbl.match, 'l') then
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

  -- Automatically set 'cursorlineopt'
  {
    { 'WinEnter' },
    {
      once = true,
      group = 'AutoCursorLineOpt',
      callback = function()
        local winlist = vim.api.nvim_list_wins()
        for _, win in ipairs(winlist) do
          vim.api.nvim_win_set_option(win, 'cursorlineopt', 'number')
        end
      end,
    },
  },
  {
    { 'BufWinEnter', 'WinEnter', 'InsertLeave' },
    {
      group = 'AutoCursorLineOpt',
      callback = function()
        vim.defer_fn(function()
          if
            vim.bo.buftype == ''
            and not vim.wo.diff
            and vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1
            and vim.opt.cursorlineopt:get()[1] ~= 'both'
          then
            vim.cmd.setlocal('cursorlineopt=both')
          end
        end, 10)
      end,
    },
  },
  {
    { 'WinLeave', 'InsertEnter' },
    {
      group = 'AutoCursorLineOpt',
      command = "if &bt ==? '' | setlocal cursorlineopt=number",
    },
  },
  {
    { 'OptionSet' },
    {
      pattern = 'diff',
      group = 'AutoCursorLineOpt',
      callback = function()
        if vim.v.option_new == '1' then
          vim.cmd.setlocal('cursorlineopt=number')
        elseif
          vim.bo.buftype == ''
          and vim.fn.match(vim.fn.mode(), '[iRsS\x13].*') == -1
        then
          -- Fix cursorlineopt being set to 'both' for all
          -- windows when leaving diff mode using ':diffoff!'
          vim.defer_fn(function()
            vim.cmd.setlocal('cursorlineopt=both')
          end, 10)
        end
      end,
    },
  },

  -- Update folds on BufEnter
  {
    { 'BufWinEnter', 'WinEnter' },
    {
      group = 'UpdateFolds',
      callback = function(tbl)
        if not vim.b[tbl.buf].foldupdated then
          vim.b[tbl.buf].foldupdated = true
          vim.cmd.normal('zx')
        end
      end
    },
  },
}

set_autocmds(autocmds)
