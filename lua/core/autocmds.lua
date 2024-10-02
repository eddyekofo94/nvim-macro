local autocmd = vim.api.nvim_create_autocmd
local groupid = vim.api.nvim_create_augroup
local contains = vim.tbl_contains

local utils = require "utils.general"
local Buffer = require "utils.buffer"
local special_filetypes = require("utils.fs").special_filetypes
-- local augroup = utils.create_augroup
local opt = vim.opt

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
local function augroup(group, ...)
  local id = groupid(group, {})
  for _, a in ipairs { ... } do
    a[2].group = id
    autocmd(unpack(a))
  end
end

-- Disabled
-- autocmd("BufWinEnter", {
--   callback = function(data)
--     Buffer.open_help(data.buf)
--   end,
--   -- group = general,
--   desc = "Redirect help to floating window",
-- })

augroup("BigFileSettings", {
  "BufReadPre",
  {
    desc = "Set settings for large files.",
    callback = function(info)
      vim.b.bigfile = false
      local stat = vim.uv.fs_stat(info.match)
      if stat and stat.size > 1024000 then
        vim.b.bigfile = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ""
        vim.opt_local.statuscolumn = ""
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
        vim.opt_local.winbar = ""
        vim.opt_local.syntax = ""
        autocmd("BufReadPost", {
          once = true,
          buffer = info.buf,
          callback = function()
            vim.opt_local.syntax = ""
            return true
          end,
        })
      end
    end,
  },
})

augroup("YankHighlight", {
  "TextYankPost",
  {
    desc = "Highlight the selection on yank.",
    callback = function()
      pcall(vim.highlight.on_yank, {
        higroup = "HighlightedYankRegion",
        timeout = 300,
      })
    end,
  },
})

augroup("Autosave", {
  { "BufLeave", "WinLeave", "FocusLost" },
  {
    nested = true,
    desc = "Autosave on focus change.",
    callback = function(info)
      if vim.bo[info.buf].bt == "" then
        vim.cmd.update {
          mods = { emsg_silent = true },
        }
      end
    end,
  },
})

augroup("WinCloseJmp", {
  "WinClosed",
  {
    nested = true,
    desc = "Jump to last accessed window on closing the current one.",
    command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
  },
})

augroup("LastPosJmp", {
  "BufReadPost",
  {
    desc = "Last position jump.",
    callback = function(info)
      local ft = vim.bo[info.buf].ft
      -- don't apply to git messages
      if ft ~= "gitcommit" and ft ~= "gitrebase" then
        vim.cmd.normal {
          'g`"zvzz',
          bang = true,
          mods = { emsg_silent = true },
        }
      end
    end,
  },
})

augroup("AutoCwd", {
  { "BufWinEnter", "FileChangedShellPost" },
  {
    pattern = "*",
    desc = "Automatically change local current directory.",
    callback = function(info)
      if info.file == "" or vim.bo[info.buf].bt ~= "" then
        return
      end
      local buf = info.buf
      local win = vim.api.nvim_get_current_win()

      vim.schedule(function()
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or not vim.api.nvim_win_get_buf(win) == buf
        then
          return
        end
        vim.api.nvim_win_call(win, function()
          local current_dir = vim.fn.getcwd(0)
          local target_dir = vim.fs.root(info.file, require("utils.fs").root_patterns) or vim.fs.dirname(info.file)
          local stat = target_dir and vim.uv.fs_stat(target_dir)
          -- Prevent unnecessary directory change, which triggers
          -- DirChanged autocmds that may update winbar unexpectedly
          if stat and stat.type == "directory" and current_dir ~= target_dir then
            pcall(vim.cmd.lcd, target_dir)
          end
        end)
      end)
    end,
  },
})

augroup("PromptBufKeymaps", {
  "BufEnter",
  {
    desc = "Undo automatic <C-w> remap in prompt buffers.",
    callback = function(info)
      if vim.bo[info.buf].buftype == "prompt" then
        vim.keymap.set("i", "<C-w>", "<C-S-W>", { buffer = info.buf })
      end
    end,
  },
})

augroup("QuickFixAutoOpen", {
  "QuickFixCmdPost",
  {
    desc = "Open quickfix window if there are results.",
    callback = function(info)
      if #vim.fn.getqflist() > 1 then
        vim.schedule(vim.cmd[info.match:find "^l" and "lwindow" or "cwindow"])
      end
    end,
  },
})

augroup("KeepWinRatio", {
  { "VimResized", "TabEnter" },
  {
    desc = "Keep window ratio after resizing nvim.",
    callback = function()
      vim.cmd.wincmd "="
      require("utils.win").restratio(vim.api.nvim_tabpage_list_wins(0))
    end,
  },
}, {
  { "TermOpen", "WinResized", "WinNew" },
  {
    desc = "Record window ratio.",
    callback = function()
      -- Don't record ratio if window resizing is caused by vim resizing
      -- (changes in &lines or &columns)
      local lines, columns = vim.go.lines, vim.go.columns
      local _lines, _columns = vim.g._lines, vim.g._columns
      if _lines and lines ~= _lines or _columns and columns ~= _columns then
        vim.g._lines = lines
        vim.g._columns = columns
        return
      end
      require("utils.win").saveratio(vim.v.event.windows)
    end,
  },
})

-- Show cursor line and cursor column only in current window
augroup("AutoHlCursorLine", {
  "WinEnter",
  {
    desc = "Show cursorline and cursorcolumn in current window.",
    callback = function()
      if vim.w._cul and not vim.wo.cul then
        vim.wo.cul = true
        vim.w._cul = nil
      end
      if vim.w._cuc and not vim.wo.cuc then
        vim.wo.cuc = true
        vim.w._cuc = nil
      end

      local prev_win = vim.fn.win_getid(vim.fn.winnr "#")
      if prev_win ~= 0 then
        local w = vim.w[prev_win]
        local wo = vim.wo[prev_win]
        w._cul = wo.cul
        w._cuc = wo.cuc
        wo.cul = false
        wo.cuc = false
      end
    end,
  },
})

augroup("FixCmdLineIskeyword", {
  "CmdLineEnter",
  {
    desc = "Have consistent &iskeyword and &lisp in Ex command-line mode.",
    pattern = "[:>/?=@]",
    callback = function(info)
      -- Don't set &iskeyword and &lisp settings in insert/append command-line
      -- ('-'), if we are inserting into a lisp file, we want to have the same
      -- behavior as in insert mode
      --
      -- Change &iskeyword in search command-line ('/' or '?'), because we are
      -- searching for regex patterns not literal lisp words
      vim.g._isk_lisp_buf = info.buf
      vim.g._isk_save = vim.bo[info.buf].isk
      vim.g._lisp_save = vim.bo[info.buf].lisp
      vim.cmd.setlocal "isk&"
      vim.cmd.setlocal "lisp&"
    end,
  },
}, {
  "CmdLineLeave",
  {
    desc = "Restore &iskeyword after leaving command-line mode.",
    pattern = "[:>/?=@]",
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

-- INFO: This is where background (bg) of special buffers are set
augroup("SpecialBufHl", {
  { "BufWinEnter", "BufNew", "FileType", "TermOpen" },
  {
    desc = "Set background color for special buffers.",
    callback = function(info)
      if vim.bo[info.buf].bt == "" then
        return
      end
      -- Current window isn't necessarily the window of the buffer that
      -- triggered the event, use `bufwinid()` to get the first window of
      -- the triggering buffer. We can also use `win_findbuf()` to get all
      -- windows that display the triggering buffer, but it is slower and using
      -- `bufwinid()` is enough for our purpose.
      local winid = vim.fn.bufwinid(info.buf)
      if winid == -1 then
        return
      end
      vim.api.nvim_win_call(winid, function()
        local wintype = vim.fn.win_gettype()
        if wintype == "popup" or wintype == "autocmd" then
          return
        end
        vim.opt_local.winhl:append {
          Normal = "NormalSpecial",
          FloatBorder = "NormalSpecial",
          EndOfBuffer = "NormalSpecial",
        }
      end)
    end,
  },
}, {
  { "UIEnter", "ColorScheme", "OptionSet", "WinEnter" },
  {
    desc = "Set special buffer normal hl.",
    callback = function(info)
      if info.event == "OptionSet" and info.match ~= "background" then
        return
      end
      local hl = require "utils.hl"
      local blended = hl.blend("Normal", "NormalFloat")
      hl.set_default(0, "NormalSpecial", blended)
      hl.set_default(0, "EndOfBuffer", blended)
    end,
  },
})

-- Close certain filetypes by pressing q.
-- autocmd({ "UIEnter", "ColorScheme", "OptionSet" }, {
--   pattern = { "*" },
--   callback = function(event)
--     local is_eligible = vim.wo.previewwindow
--       or contains(special_filetypes, vim.bo.buftype)
--       or contains(special_filetypes, vim.bo.filetype)
--     if is_eligible then
--       vim.bo[event.buf].buflisted = false
--       local bufnr = event.buf
--
--       vim.opt_local.winhl:append {
--         Normal = "NormalSpecial",
--         FloatBorder = "NormalSpecial",
--         EndOfBuffer = "NormalSpecial",
--       }
--
--       local hl = require "utils.hl"
--       local blended = hl.blend("Normal", "NormalFloat")
--
--       hl.set_default(bufnr, "NormalSpecial", blended)
--       hl.set_default(bufnr, "EndOfBuffer", blended)
--     end
--   end,
-- })
-- INFO: personal autocommands

-- automatically cleanup dirs to prevent bloating.
-- once a week, on first FocusLost, delete files older than 30/60 days.
vim.api.nvim_create_autocmd("FocusLost", {
  once = true,
  callback = function()
    if os.date "%a" == "Mon" then
      vim.fn.system { "find", opt.viewdir:get(), "-mtime", "+60d", "-delete" }
      vim.fn.system { "find", opt.undodir:get()[1], "-mtime", "+30d", "-delete" }
    end
  end,
})

-- if last command was line-jump, remove it from history to reduce noise
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function(ctx)
    if not ctx.match == ":" then
      return
    end
    vim.defer_fn(function()
      local lineJump = vim.fn.histget(":", -1):match "^%d+$"
      if lineJump then
        vim.fn.histdel(":", -1)
      end
    end, 100)
  end,
})

-- make `:substitute` also notify how many changes were made
-- works, as `CmdlineLeave` is triggered before the execution of the command
vim.api.nvim_create_autocmd("CmdlineLeave", {
  callback = function(ctx)
    if not ctx.match == ":" then
      return
    end
    local cmdline = vim.fn.getcmdline()
    local isSubstitution = cmdline:find "s ?/.+/.-/%a*$"
    if isSubstitution then
      vim.cmd(cmdline .. "ne")
    end
  end,
})

---Change window-local directory to `dir`
---@return nil
-- local function lcd(dir)
--   local ok = pcall(vim.cmd.lcd, dir)
--   if not ok then
--     vim.notify_once("failed to cd to " .. dir, vim.log.levels.WARN)
--   end
-- end

local fs_change = augroup "ChangeToCurDir"
autocmd({ "BufEnter", "WinEnter", "BufWinEnter" }, {
  group = fs_change,
  pattern = "*",
  desc = "Automatically change local current directory.",
  callback = function(info)
    if info.file == "" or vim.bo[info.buf].bt ~= "" then
      return
    end
    local buf = info.buf
    local win = vim.api.nvim_get_current_win()

    vim.schedule(function()
      if
        not vim.api.nvim_buf_is_valid(buf)
        or not vim.api.nvim_win_is_valid(win)
        or not vim.api.nvim_win_get_buf(win) == buf
      then
        return
      end
      vim.api.nvim_win_call(win, function()
        local current_dir = vim.fn.getcwd(0)
        local target_dir = require("utils").fs.cwd_dir(info.file) or vim.fs.dirname(info.file)
        local stat = target_dir and vim.uv.fs_stat(target_dir)
        -- Prevent unnecessary directory change, which triggers
        -- DirChanged autocmds that may update winbar unexpectedly
        if stat and stat.type == "directory" and current_dir ~= target_dir then
          print("cd to " .. target_dir)
          pcall(vim.cmd.lcd, target_dir)
        end
      end)
    end)
  end,
})

-- Center the buffer after search in cmd mode
autocmd({ "CmdLineLeave", "WinEnter" }, {
  callback = function()
    if vim.api.nvim_get_mode().mode == "i" then
      return
    end

    vim.cmd.normal {
      "zz",
      bang = true,
      mods = { emsg_silent = true },
    }
  end,
})

local disable_codespell = augroup "DisableCodespell"
autocmd({ "BufEnter" }, {
  group = disable_codespell,
  pattern = { "*.log", "" },
  callback = function()
    vim.diagnostic.enable(false)
  end,
})

autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove { "c", "r", "o" }
  end,
  desc = "Disable New Line Comment",
})

-- always open quickfix window automatically.
-- this uses cwindows which will open it only if there are entries.
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  group = vim.api.nvim_create_augroup("AutoOpenQuickfix", { clear = true }),
  pattern = { "[^l]*" },
  command = "cwindow",
})

autocmd("BufHidden", {
  desc = "Delete [No Name] buffers",
  pattern = {},
  callback = function(data)
    if data.file == "" and vim.bo[data.buf].buftype == "" and not vim.bo[data.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, data.buf, {})
      end)
    end
  end,
})

local fix_virtual_edit_pos = augroup "FixVirtualEditCursorPos"
autocmd("CursorMoved", {
  desc = "Record cursor position in visual mode if virtualedit is set.",
  group = fix_virtual_edit_pos,
  callback = function()
    if vim.wo.ve:find "all" then
      vim.w.ve_cursor = vim.fn.getcurpos()
    end
  end,
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  -- group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- AUTO-CLOSE BUFFERS whose files do not exist anymore
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "QuickFixCmdPost" }, {
  -- INFO also trigger on `QuickFixCmdPost`, in case a make command deletes file
  callback = function(ctx)
    local bufnr = ctx.buf
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end

      local function fileExists(bufpath)
        return vim.loop.fs_stat(bufpath) ~= nil
      end

      -- check if buffer was deleted
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local isSpecialBuffer = vim.bo[bufnr].buftype ~= ""
      local isNewBuffer = bufname == ""
      -- prevent the temporary buffers from conform.nvim's "injected"
      -- formatter to be closed by this (filename is like "README.md.5.lua")
      local conformTempBuf = bufname:find "%.md%.%d+%.%l+$"
      if fileExists(bufname) or isSpecialBuffer or isNewBuffer or conformTempBuf then
        return
      end

      -- open last existing oldfile
      vim.notify(("%q does not exist anymore."):format(vim.fs.basename(bufname)))
      for _, oldfile in pairs(vim.v.oldfiles) do
        if fileExists(oldfile) then
          -- vim.cmd.edit can still fail, as the fileExistence check
          -- apparently sometimes uses a cache, where the file still exists
          local success = pcall(vim.cmd.edit, oldfile)
          if success then
            return
          end
        end
      end
    end, 300)
  end,
})

vim.api.nvim_create_autocmd({ "FileChangedShellPost", "DiagnosticChanged", "LspProgress" }, {
  group = vim.api.nvim_create_augroup("StatusLine", {}),
  command = "redrawstatus",
})
