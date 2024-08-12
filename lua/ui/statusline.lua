local statusline = {}

local fs = require "utils.fs"
local utils = require "utils"
local groupid = vim.api.nvim_create_augroup("StatusLine", {})

local options = {
  diagnostics = {
    " 0 ",
    "󰅚 0 ",
  },
  default_icon = "󰈚 ",
  hl = {},
  symbols = {
    modified = "● ",
    readonly = "🔒 ",
    unnamed = "[No Name]",
    newfile = "[New]",
  },
  file_status = true,
  newfile_status = false,
  path = 0,
  shorting_target = 40,
}

local stbufnr = function()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

local assets = {
  dir = "󰉖 ",
  file = "󰈙 ",
}

local diag_signs_default_text = { "E", "W", "I", "H" }

local diag_severity_map = {
  [1] = "ERROR",
  [2] = "WARN",
  [3] = "INFO",
  [4] = "HINT",
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  HINT = 4,
}

---@param severity integer|string
---@return string
local function get_diag_sign_text(severity)
  local diag_config = vim.diagnostic.config()
  local signs_text = diag_config and diag_config.signs and type(diag_config.signs) == "table" and diag_config.signs.text
  return signs_text and (signs_text[severity] or signs_text[diag_severity_map[severity]])
    or (diag_signs_default_text[severity] or diag_signs_default_text[diag_severity_map[severity]])
end

function statusline.lsp_progress()
  -- local progress = require("utils.lsp.progress").lsp_progress()
  local progress = require("utils.lsp.lsp_progress").lsp_progress()

  -- require("lsp-progress").progress {
  --   max_size = 80,
  --   format = function(messages)
  --     if #messages > 0 then
  --       return #messages > 0 and table.concat(messages, " ") or ""
  --     end
  --     return ""
  --   end,
  -- }
  return utils.stl.hl(string.format("%s", progress), "StatuslineInactive")
end

---Get string representation of diagnostics for current buffer
---@return string
function statusline.diag()
  if vim.b.diag_str_cache then
    return vim.b.diag_str_cache
  end
  local str = ""
  local buf_cnt = vim.b.diag_cnt_cache or {}
  for serverity_nr, severity in ipairs { "Error", "Warn", "Info", "Hint" } do
    local cnt = buf_cnt[serverity_nr] or 0
    if cnt > 0 then
      local icon_text = get_diag_sign_text(serverity_nr)
      local icon_hl = "StatusLineDiagnostic" .. severity
      str = str .. (str == "" and "" or " ") .. utils.stl.hl(icon_text, icon_hl) .. cnt
    end
  end
  if str:find "%S" then
    str = str .. " "
  end
  vim.b.diag_str_cache = str
  return str
end

function statusline.diagnostics()
  local errors = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.INFO })

  if vim.bo.ft:gsub("^%l", string.lower) == "term" then
    return
  end

  errors = (errors and errors > 0) and ("E" .. errors .. " ") or ""
  warnings = (warnings and warnings > 0) and ("W" .. warnings .. " ") or ""
  hints = (hints and hints > 0) and ("H" .. hints .. " ") or ""
  info = (info and info > 0) and ("I" .. info .. " ") or ""

  local icons = string.format(
    "%s%s%s%s",
    utils.stl.hl(tostring(errors), "StatusLineLspError"),
    utils.stl.hl(tostring(warnings), "StatusLineLspWarning"),
    utils.stl.hl(tostring(hints), "StatusLineLspHint"),
    utils.stl.hl(tostring(info), "StatusLineLspInfo")
  )

  if errors == "" and warnings == "" and hints == "" and info == "" then
    return ""
  end

  local diagnostic_icons = (vim.o.columns > 140 and " - " .. icons or "")

  return utils.stl.hl(tostring(diagnostic_icons), "StatusLine")
end

function statusline.get_lsp_name()
  local buf_clients = vim.lsp.get_clients(0)
  -- local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  local ok, conform = pcall(require, "conform")
  local formatters = table.concat(conform.list_all_formatters(), " ")
  if ok then
    for formatter in formatters:gmatch "%w+" do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end

  local hash = {}
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, ", ")

  return "  " .. language_servers
end

function statusline.search_count()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local result = vim.fn.searchcount { maxcount = 999, timeout = 250 }

  if result.incomplete == 1 or next(result) == nil then
    return ""
  end

  return string.format("[%d/%d]", result.current, math.min(result.total, result.maxcount))
end

function statusline.file_info()
  local symbols = {}
  local fname_hl = "StatusLineFilename"
  local fpath = statusline.filepath()
  local filename = statusline.filename()
  local devicons_present, devicons = pcall(require, "nvim-web-devicons")
  local icon = ""

  local errors = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })

  if devicons_present then
    local ft_icon = devicons.get_icon(filename)
    icon = (ft_icon ~= nil and ft_icon) or icon
  end

  if filename ~= options.symbols.unnamed then
    if options.file_status then
      if vim.bo.modified then
        table.insert(symbols, options.symbols.modified)
        fname_hl = "StatuslineModified"
      end
      if vim.bo.modifiable == false or vim.bo.readonly == true then
        table.insert(symbols, options.symbols.readonly)
      end
    end
  else
    fpath = ""
    filename = statusline.ft()
  end

  if options.newfile_status and fs.is_new_file() then
    table.insert(symbols, options.symbols.newfile)
  end

  if errors > 0 then
    fname_hl = "StatuslineError"
  end

  local file_symbol = (#symbols > 0 and " " .. table.concat(symbols, "") or "")
  return string.format(
    "%s%s%s",
    "%#StatuslineInactive#" .. icon .. fpath,
    "%#" .. fname_hl .. "#" .. filename,
    file_symbol
  )
end

function statusline.macro()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register .. " "
  end
end

statusline.lazy_plug_count = function()
  local stats = require("lazy").stats()
  return " " .. stats.count
end

statusline.lazy_startup = function()
  local stats = require("lazy").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  return " " .. ms .. "ms"
end

function statusline.lazy_updates()
  return require("lazy.status").updates()
end

statusline.project_name = function()
  local fnamemodify = vim.fn.fnamemodify
  local cwd = fnamemodify(vim.fn.getcwd(), ":t")
  return cwd
end

--  BUG: 2024-06-03 - keep throwing some error about table concat
statusline.formatter = function()
  local ok, conform = pcall(require, "conform")
  if not ok then
    return
  end

  -- local formatters = conform.list_formatters_for_buffer()
  local formatters = {}

  local function add_formatter(client)
    if client ~= "" then
      table.insert(formatters, client)
    end
  end

  -- for formatter in conform.list_formatters(0) do
  --   if formatter then
  --     add_formatter(formatter)
  --   end
  -- end
  -- return ""
  return conform.list_formatters(0)
  -- return vim.tbl_isempty(formatters) and "" or string.format("(%s) ", table.concat(formatters, ", "))
end

statusline.fmt = function()
  local buf_clients = vim.lsp.get_clients()
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end

  local buf_client_names = {}
  local ok, conform = pcall(require, "conform")
  local formatters = table.concat(conform.formatters_by_ft[vim.bo.filetype], " ")

  if ok then
    for formatter in formatters:gmatch "%w+" do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end
  local hash = {}
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end

  local language_servers = table.concat(unique_client_names, ", ")
  return "  " .. language_servers
end

function statusline.filename()
  local fname = vim.fn.expand "%:t"
  if fname == "" then
    return "[No Name]"
  end
  return fname
end

function statusline.filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
  if fpath == "" or fpath == "." then
    return " "
  end

  return string.format(" %%<%s/", fpath)
end

function statusline.get_win_cwd()
  local winid = vim.fn.bufwinid(0)
  local current_dir = vim.fn.getcwd(winid)

  -- local current_dir = vim.fn.getcwd(0)
  return current_dir
end

function statusline.cwd()
  local icon = "󰉋 "
  local name = fs.shorten_path(fs.get_root(), "/", 0)
  name = (name:match "([^/\\]+)[/\\]*$" or name) .. " "

  return (vim.o.columns > 85 and ("%#StatuslineInactive#" .. icon .. name)) or ""
end

function statusline.lsp()
  local buf_clients = vim.lsp.get_clients()
  local buf_client_names = {}

  ---@param client string
  local function add_client(client)
    if client ~= "" then
      table.insert(buf_client_names, client)
    end
  end

  if next(buf_clients) == nil then
    return "  No servers"
  end

  if rawget(vim, "lsp") then
    for _, client in ipairs(buf_clients) do
      if client.attached_buffers[stbufnr()] and client.name ~= "null-ls" then
        add_client(client.name)
      end
    end
  end

  -- return (vim.o.columns > 100 and "   " .. buf_client_names .. " ") or ""
  -- return ""
  return vim.tbl_isempty(buf_client_names) and "  No servers"
    or (vim.o.columns > 80 and string.format("[ %s ] ", table.concat(buf_client_names, ", ")))
end

---Get diff stats for current buffer
---@return string
function statusline.gitdiff()
  -- Integration with gitsigns.nvim
  ---@diagnostic disable-next-line: undefined-field
  local git_info = vim.b.gitsigns_status_dict or utils.git.diffstat()
  local added = git_info.added or 0
  local changed = git_info.changed or 0
  local removed = git_info.removed or 0
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head or utils.git.branch()
  branch = branch == "" and "" or " " .. branch

  if not git_info or git_info.head == "" then
    return ""
  end

  if added == 0 and removed == 0 and changed == 0 then
    return branch
  end

  return string.format(
    "%s +%s ~%s -%s ",
    utils.stl.hl(tostring(branch), "StatusLine"),
    utils.stl.hl(tostring(added), "StatusLineGitAdd"),
    utils.stl.hl(tostring(changed), "StatusLineGitChange"),
    utils.stl.hl(tostring(removed), "StatusLineGitDelete")
  )
end

--- A provider function for showing if treesitter is connected
---@return string # function for outputting TS if treesitter is connected
-- @see astronvim.utils.status.utils.stylize
function statusline.treesitter_status()
  local utils_buffer = require "utils.buffer"
  local cur_bf = vim.api.nvim_get_current_buf()
  local ts_enabled
  local res = "TS"

  if utils_buffer.is_buf_valid(cur_bf) then
    ts_enabled = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
    if ts_enabled then
      local has_parser = require("nvim-treesitter.parsers").has_parser()
      if has_parser then
        return tostring(res)
        -- return utils.stl.hl(tostring(res), "StatuslineInactive")
      end
    end
  end

  return res
end

---Get current filetype
---@return string
function statusline.ft()
  return vim.bo.ft == "" and "" or " " .. vim.bo.ft:gsub("^%l", string.upper) .. " "
end

function statusline.line_percentage()
  local curr_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  if curr_line == 1 then
    return "Top "
  elseif curr_line == lines then
    return "Bot "
  else
    return string.format("%2d%%%% ", math.ceil(curr_line / lines * 99))
  end
end

statusline.section_location = function()
  return "%2l:%-2v"
end

function statusline.line_info()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %l:%c %P "
end

---@return string
function statusline.wordcount()
  local words, wordcount = 0, nil
  if vim.b.wc_words and vim.b.wc_changedtick == vim.b.changedtick then
    words = vim.b.wc_words
  else
    wordcount = vim.fn.wordcount()
    words = wordcount.words
    vim.b.wc_words = words
    vim.b.wc_changedtick = vim.b.changedtick
  end
  local vwords = vim.fn.mode():find "^[vsVS\x16\x13]" and (wordcount or vim.fn.wordcount()).visual_words
  return words == 0 and ""
    or (vwords and vwords > 0 and vwords .. "/" or "") .. words .. (words > 1 and " words" or " word")
end

---Text filetypes
---@type table<string, true>
local ft_text = {
  [""] = true,
  ["tex"] = true,
  ["markdown"] = true,
  ["text"] = true,
}

---Additional info for the current buffer enclosed in parentheses
---@return string
function statusline.info()
  if vim.bo.bt ~= "" then
    return ""
  end
  local info = {}
  ---@param section string
  local function add_section(section)
    if section ~= "" then
      table.insert(info, section)
    end
  end

  add_section(statusline.ft())
  if ft_text[vim.bo.ft] and not vim.b.bigfile then
    add_section(statusline.wordcount())
  end

  -- add_section(statusline.wordcount())
  -- add_section(statusline.lazy_updates())
  -- add_section(statusline.lazy_plug_count())
  -- add_section(statusline.lazy_startup())
  -- add_section(statusline.gitdiff())
  -- add_section(statusline.lsp()) -- INFO: this is disabled for now
  add_section(statusline.lint_progress())
  -- add_section(statusline.formatter())
  -- add_section(get_lsp_name())
  add_section(statusline.treesitter_status())
  -- (vim.o.columns > 140 and " - " .. icons or "")

  return vim.tbl_isempty(info) and "" or (vim.o.columns > 80 and string.format("(%s) ", table.concat(info, ", ")))
end

statusline.navic = function()
  if not pcall(require, "nvim-navic") then
    return ""
  end
  local nvim_navic = require "nvim-navic"
  if not nvim_navic.is_available() then
    return ""
  end
  return nvim_navic.get_location()
end

--  BUG: 2024-06-29 - not sure if this is working
statusline.lint_progress = function()
  if not pcall(require, "lint") then
    return ""
  end

  local linters = require("lint").get_running()

  if #linters < 1 then
    return "󰦕"
  end
  return "󱉶 " .. table.concat(linters, ", ")
end

---Set default highlight groups for statusline components
---@return  nil
local function set_default_hlgroups()
  local default_attr = utils.hl.get(0, {
    name = "StatusLine",
    link = false,
    winhl_link = false,
  })

  ---@param hlgroup_name string
  ---@param attr table
  ---@return nil
  local function sethl(hlgroup_name, attr)
    local merged_attr = vim.tbl_deep_extend("keep", attr, default_attr)
    utils.hl.set_default(0, hlgroup_name, merged_attr)
  end
  sethl("StatusLineGitAdded", { fg = "GitSignsAdd" })
  sethl("StatusLineGitChanged", { fg = "GitSignsChange" })
  sethl("StatusLineGitRemoved", { fg = "GitSignsDelete" })
  sethl("StatusLineDiagnosticHint", { fg = "DiagnosticSignHint" })
  sethl("StatusLineDiagnosticInfo", { fg = "DiagnosticSignInfo" })
  sethl("StatusLineDiagnosticWarn", { fg = "DiagnosticSignWarn" })
  sethl("StatusLineDiagnosticError", { fg = "DiagnosticSignError" })
  sethl("StatusLineHeader", { fg = "TabLine", bg = "fg", reverse = true })
  sethl("StatusLineHeaderModified", {
    fg = "Special",
    bg = "fg",
    reverse = true,
  })
end
set_default_hlgroups()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = groupid,
  callback = set_default_hlgroups,
})

return statusline
