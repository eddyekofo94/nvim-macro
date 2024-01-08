---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
local function au(group, ...)
  local groupid = vim.api.nvim_create_augroup(group, {})
  for _, autocmd in ipairs({ ... }) do
    autocmd[2].group = groupid
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

au('BigFileSettings', {
  'BufReadPre',
  {
    desc = 'Set settings for large files.',
    callback = function(info)
      vim.b.midfile = false
      vim.b.bigfile = false
      local stat = vim.uv.fs_stat(info.match)
      if not stat then
        return
      end
      if stat.size > 48000 then
        vim.b.midfile = true
        vim.api.nvim_create_autocmd('BufReadPost', {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.schedule(function()
              pcall(vim.treesitter.stop, info.buf)
            end)
            return true
          end,
        })
      end
      if stat.size > 1024000 then
        vim.b.bigfile = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.winbar = ''
        vim.api.nvim_create_autocmd('BufReadPost', {
          buffer = info.buf,
          once = true,
          callback = function()
            vim.opt_local.syntax = ''
            return true
          end,
        })
      end
    end,
  },
})

-- Workaround for nvim treating whole Chinese sentence as a single word
-- Ideally something like https://github.com/neovim/neovim/pull/14029
-- will be merged to nvim, also see
-- https://github.com/neovim/neovim/issues/13967
au('CJKFileSettings', {
  'BufEnter',
  {
    desc = 'Settings for CJK files.',
    callback = function(info)
      local lnum_nonblank = math.max(0, vim.fn.nextnonblank(1) - 1)
      local lines = vim.api.nvim_buf_get_lines(
        info.buf,
        lnum_nonblank,
        lnum_nonblank + 64,
        false
      )
      for _, line in ipairs(lines) do
        if line:match('[\128-\255]') then
          vim.opt_local.linebreak = false
          return
        end
      end
    end,
  },
})

au('YankHighlight', {
  'TextYankPost',
  {
    desc = 'Highlight the selection on yank.',
    callback = function()
      vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    end,
  },
})

au('Autosave', {
  { 'BufLeave', 'WinLeave', 'FocusLost' },
  {
    nested = true,
    desc = 'Autosave on focus change.',
    callback = function(info)
      if
        vim.bo[info.buf].bt == ''
        and (vim.uv.fs_stat(info.file) or {}).type == 'file'
      then
        vim.cmd.update({
          mods = { emsg_silent = true },
        })
      end
    end,
  },
})

au('WinCloseJmp', {
  'WinClosed',
  {
    nested = true,
    desc = 'Jump to last accessed window on closing the current one.',
    command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
  },
})

au('LastPosJmp', {
  'BufReadPost',
  {
    desc = 'Last position jump.',
    callback = function(info)
      local ft = vim.bo[info.buf].ft
      -- don't apply to git messages
      if ft ~= 'gitcommit' and ft ~= 'gitrebase' then
        vim.cmd.normal({
          'g`"zvzz',
          bang = true,
          mods = { emsg_silent = true },
        })
      end
    end,
  },
})

au('AutoCwd', {
  { 'BufWinEnter', 'FileChangedShellPost' },
  {
    pattern = '*',
    desc = 'Automatically change local current directory.',
    callback = function(info)
      vim.schedule(function()
        if
          info.file == ''
          or not vim.api.nvim_buf_is_valid(info.buf)
          or vim.bo[info.buf].bt ~= ''
          or (vim.uv.fs_stat(info.file) or {}).type ~= 'file'
        then
          return
        end
        local current_dir = vim.fn.getcwd(0)
        local target_dir = require('utils').fs.proj_dir(info.file)
          or vim.fs.dirname(info.file)
        local stat = target_dir and vim.uv.fs_stat(target_dir)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if current_dir ~= target_dir and stat and stat.type == 'directory' then
          vim.cmd.lcd(target_dir)
        end
      end)
    end,
  },
})

au('PromptBufKeymaps', {
  'BufEnter',
  {
    desc = 'Undo automatic <C-w> remap in prompt buffers.',
    callback = function(info)
      if vim.bo[info.buf].buftype == 'prompt' then
        vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
      end
    end,
  },
})

au('QuickFixAutoOpen', {
  'QuickFixCmdPost',
  {
    desc = 'Open quickfix window if there are results.',
    callback = function(info)
      if #vim.fn.getqflist() <= 1 then
        return
      end
      if vim.startswith(info.match, 'l') then
        vim.schedule(function()
          vim.cmd.lwindow({
            mods = { split = 'belowright' },
          })
        end)
      else
        vim.schedule(function()
          vim.cmd.cwindow({
            mods = { split = 'botright' },
          })
        end)
      end
    end,
  },
})

au('EqualWinSize', {
  'VimResized',
  {
    desc = 'Make window equal size on VimResized.',
    command = 'wincmd =',
  },
})

-- Show cursor line and cursor column only in current window
au('AutoHlCursorLine', {
  { 'BufWinEnter', 'WinEnter', 'UIEnter' },
  {
    desc = 'Show cursorline and cursorcolumn in current window.',
    callback = function()
      if vim.fn.mode():match('^[itRsS\x13]') then
        return
      end
      if vim.w._cul and not vim.wo.cul then
        vim.wo.cul = true
        vim.w._cul = nil
      end
      if vim.w._cuc and not vim.wo.cuc then
        vim.wo.cuc = true
        vim.w._cuc = nil
      end
    end,
  },
}, {
  'WinLeave',
  {
    desc = 'Hide cursorline and cursorcolumn in other windows.',
    callback = function()
      if vim.wo.cul then
        vim.w._cul = true
        vim.wo.cul = false
      end
      if vim.wo.cuc then
        vim.w._cuc = true
        vim.wo.cuc = false
      end
    end,
  },
}, {
  'ModeChanged',
  {
    desc = 'Hide cursorline and cursorcolumn in insert mode.',
    pattern = { '[itRss\x13]*:*', '*:[itRss\x13]*' },
    callback = function()
      if vim.v.event.new_mode:match('^[itRss\x13]') then
        if vim.wo.cul then
          vim.w._cul = true
          vim.wo.cul = false
        end
        if vim.wo.cuc then
          vim.w._cuc = true
          vim.wo.cuc = false
        end
      else
        if vim.w._cul and not vim.wo.cul then
          vim.wo.cul = true
          vim.w._cul = nil
        end
        if vim.w._cuc and not vim.wo.cuc then
          vim.wo.cuc = true
          vim.w._cuc = nil
        end
      end
    end,
  },
})

au('TextwidthRelativeColorcolumn', {
  'OptionSet',
  {
    pattern = 'textwidth',
    desc = 'Set colorcolumn according to textwidth.',
    callback = function()
      if vim.v.option_new ~= 0 then
        vim.opt_local.colorcolumn = '+1'
      end
    end,
  },
})

au('UpdateTimestamp', {
  'BufWritePre',
  {
    desc = 'Update timestamp automatically.',
    callback = function(info)
      if not vim.bo[info.buf].ma or not vim.bo[info.buf].mod then
        return
      end
      local lines = vim.api.nvim_buf_get_lines(info.buf, 0, 8, false)
      local updated = false
      for idx, line in ipairs(lines) do
        local new_str, pos = line:gsub(
          'Last Updated:.*',
          'Last Updated: ' .. os.date('%a %d %b %Y %I:%M:%S %p %Z')
        )
        if pos > 0 then
          updated = true
          lines[idx] = new_str
        end
      end
      if updated then
        -- Only join further change with the previous undo block
        -- when the current undo block is a leaf node (no further change),
        -- see `:h undojoin` and `:h E790`
        local undotree = vim.fn.undotree(info.buf)
        if undotree.seq_cur == undotree.seq_last then
          vim.cmd.undojoin()
          vim.api.nvim_buf_set_lines(info.buf, 0, 8, false, lines)
        end
      end
    end,
  },
})

au('FixVirtualEditCursorPos', {
  'ModeChanged',
  {
    desc = 'Keep cursor position after entering normal mode from visual mode with virtual edit enabled.',
    pattern = '[vV\x16]*:n',
    callback = function()
      if vim.wo.ve:find('all') and vim.w.ve_cursor then
        vim.api.nvim_win_set_cursor(0, {
          vim.w.ve_cursor[2],
          vim.w.ve_cursor[3] + vim.w.ve_cursor[4] - 1,
        })
      end
    end,
  },
}, {
  'CursorMoved',
  {
    desc = 'Record cursor position in visual mode if virtualedit is set.',
    callback = function()
      if vim.wo.ve:find('all') then
        vim.w.ve_cursor = vim.fn.getcurpos()
      end
    end,
  },
})

au('FixCmdLineIskeyword', {
  'CmdLineEnter',
  {
    desc = 'Have consistent &iskeyword and &lisp in Ex command-line mode.',
    pattern = '[^/?]',
    callback = function(info)
      -- Don't set &iskeyword and &lisp settings in search command-line
      -- ('/' and '?'), if we are searching in a lisp file, we want to
      -- have the same behavior as in insert mode
      vim.g._isk_lisp_buf = info.buf
      vim.g._isk_save = vim.bo[info.buf].isk
      vim.g._lisp_save = vim.bo[info.buf].lisp
      vim.cmd.setlocal('isk&')
      vim.cmd.setlocal('lisp&')
    end,
  },
}, {
  'CmdLineLeave',
  {
    desc = 'Restore &iskeyword after leaving command-line mode.',
    pattern = '[^/?]',
    callback = function()
      if
        vim.g._isk_lisp_buf
        and vim.api.nvim_buf_is_valid(vim.g._isk_lisp_buf)
        and vim.g._isk_save ~= vim.b[vim.g._isk_lisp_buf].isk
      then
        vim.bo[vim.g._isk_lisp_buf].isk = vim.g._isk_save
        vim.bo[vim.g._isk_lisp_buf].lisp = vim.g._lisp_save
        vim.g._isk_save = nil
        vim.g._lisp_save = nil
        vim.g._isk_lisp_buf = nil
      end
    end,
  },
})

au('DeferSetSpell', {
  { 'BufReadPre', 'BufModifiedSet' },
  {
    desc = 'Defer setting spell options to improve startup time.',
    callback = function(info)
      local buf = info.buf
      local win = vim.api.nvim_get_current_win()
      if
        not vim.b[buf].spell_checked
        and not vim.b[buf].bigfile
        and not vim.wo[win].spell
        and vim.bo[buf].bt == ''
        and vim.bo[buf].ma
      then
        vim.opt_local.spell = true
      end
      vim.b[buf].spell_checked = true
    end,
  },
})

au('SpecialBufHl', {
  { 'BufWinEnter', 'FileType', 'TermOpen' },
  {
    desc = 'Set background color for special buffers.',
    callback = function(info)
      -- Current window isn't necessarily the window of the buffer that
      -- triggered the event, use `bufwinid()` to get the first window of the
      -- triggering buffer. This fixes the bug where the LSP hovering window
      -- is not highlighted correctly.
      -- We can also use `win_findbuf()` to get all windows
      -- that display the triggering buffer, but it is slower and using
      -- `bufwinid()` is enough for our purpose.
      vim.api.nvim_win_call(vim.fn.bufwinid(info.buf), function()
        -- Floating windows use `hl-NormalFloat`
        -- Map `hl-NormalFloat` to itself if it is not already
        -- set to avoid special buffer background color
        -- being applied in floating windows caused by
        -- `hl-Normal` mapping to `hl-NormalSpecial`
        local winhl = vim.opt_local.winhl
        local wintype = vim.fn.win_gettype()
        if wintype == 'popup' then
          local val = winhl:get()
          if val.Normal == 'NormalSpecial' and not val.NormalFloat then
            winhl:append({ NormalFloat = 'NormalFloat' })
          end
          return
        end

        local bt = vim.bo[info.buf].bt
        if bt == '' then
          winhl:remove('Normal')
          winhl:remove('EndOfBuffer')
          return
        end

        winhl:append({
          Normal = 'NormalSpecial',
          EndOfBuffer = 'NormalSpecial',
        })
      end)
    end,
  },
}, {
  { 'UIEnter', 'ColorScheme' },
  {
    desc = 'Set special buffer normal hl.',
    callback = function()
      local hl = require('utils.hl')
      local blended = hl.blend('Normal', 'CursorLine')
      hl.set_default(0, 'NormalSpecial', blended)
    end,
  },
})
