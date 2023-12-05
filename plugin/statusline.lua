_G.statusline = {}
local utils = require('utils')
local groupid = vim.api.nvim_create_augroup('StatusLine', {})

---@type table<string, string>
local signs_text_cache = setmetatable({}, {
  __index = function(self, key)
    local sign_def = vim.fn.sign_getdefined(key)[1]
    self[key] = sign_def and sign_def.text
    return self[key] or ''
  end,
})

-- stylua: ignore start
local modes = {
  ['n']      = 'NO',
  ['no']     = 'OP',
  ['nov']    = 'OC',
  ['noV']    = 'OL',
  ['no\x16'] = 'OB',
  ['\x16']   = 'VB',
  ['niI']    = 'IN',
  ['niR']    = 'RE',
  ['niV']    = 'RV',
  ['nt']     = 'NT',
  ['ntT']    = 'TM',
  ['v']      = 'VI',
  ['vs']     = 'VI',
  ['V']      = 'VL',
  ['Vs']     = 'VL',
  ['\x16s']  = 'VB',
  ['s']      = 'SE',
  ['S']      = 'SL',
  ['\x13']   = 'SB',
  ['i']      = 'IN',
  ['ic']     = 'IC',
  ['ix']     = 'IX',
  ['R']      = 'RE',
  ['Rc']     = 'RC',
  ['Rx']     = 'RX',
  ['Rv']     = 'RV',
  ['Rvc']    = 'RC',
  ['Rvx']    = 'RX',
  ['c']      = 'CO',
  ['cv']     = 'CV',
  ['r']      = 'PR',
  ['rm']     = 'PM',
  ['r?']     = 'P?',
  ['!']      = 'SH',
  ['t']      = 'TE',
}
-- stylua: ignore end

---Get string representation of the current mode
---@return string
function statusline.mode()
  local hl = vim.bo.mod and 'StatusLineHeaderModified' or 'StatusLineHeader'
  return utils.stl.hl(' ' .. modes[vim.fn.mode()] .. ' ', hl)
end

---Get diff stats for current buffer
---@return string
function statusline.gitdiff()
  -- Integration with gitsigns.nvim
  ---@diagnostic disable-next-line: undefined-field
  local diff = vim.b.gitsigns_status_dict or utils.git.diffstat()
  local added = diff.added or 0
  local changed = diff.changed or 0
  local removed = diff.removed or 0
  if added == 0 and removed == 0 and changed == 0 then
    return ''
  end
  return string.format(
    '+%s~%s-%s',
    utils.stl.hl(tostring(added), 'StatusLineGitAdded'),
    utils.stl.hl(tostring(changed), 'StatusLineGitChanged'),
    utils.stl.hl(tostring(removed), 'StatusLineGitRemoved')
  )
end

---Get string representation of current git branch
---@return string
function statusline.branch()
  ---@diagnostic disable-next-line: undefined-field
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
    or utils.git.branch()
  return branch == '' and '' or '#' .. branch
end

---Get current filetype
---@return string
function statusline.ft()
  return vim.bo.ft == '' and '' or vim.bo.ft:gsub('^%l', string.upper)
end

---@type table<string, fun(): string>
---@diagnostic disable: undefined-field
statusline.flags = {
  md_captitle = function()
    return vim.bo.ft == 'markdown' and vim.b.captitle and 'md-cap-title' or ''
  end,
  lsp_autofmt = function()
    return vim.b.lsp_autofmt_enabled
        and not vim.tbl_isempty(vim.lsp.get_clients({
          bufnr = 0,
          method = 'textDocument/formatting',
        }))
        and 'lsp-auto-format'
      or ''
  end,
}
---@diagnostic enable: undefined-field

---@return string
function statusline.word_count()
  local wordcount = vim.fn.wordcount()
  local num_words = wordcount.words
  local num_vis_words = wordcount.visual_words
  return num_words == 0 and ''
    or (num_vis_words and num_vis_words .. '/' or '')
      .. num_words
      .. ' word'
      .. (num_words > 1 and 's' or '')
end

---Text filetypes
---@type table<string, true>
local ft_text = {
  [''] = true,
  ['tex'] = true,
  ['markdown'] = true,
  ['text'] = true,
}

---Additional info for the current buffer enclosed in parentheses
---@return string
function statusline.info()
  if vim.bo.bt ~= '' then
    return ''
  end
  local info = {}
  ---@param section string
  local function add_section(section)
    if section ~= '' then
      table.insert(info, section)
    end
  end
  add_section(statusline.ft())
  if ft_text[vim.bo.ft] and not vim.b.large_file then
    add_section(statusline.word_count())
  end
  add_section(statusline.branch())
  add_section(statusline.gitdiff())
  add_section(statusline.flags.md_captitle())
  add_section(statusline.flags.lsp_autofmt())
  return vim.tbl_isempty(info) and ''
    or string.format('(%s) ', table.concat(info, ', '))
end

local diag_str_cache = {} ---@type table<integer, string>
local diag_cnt_cache = {} ---@type table<integer, integer[]>
local diag_ws_cnt_cache = {} ---@type integer[]

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = groupid,
  desc = 'Update diagnostics cache for the status line.',
  callback = function(info)
    diag_str_cache = {}
    diag_cnt_cache[info.buf] = diag_cnt_cache[info.buf] or {}
    local buf_cnt = diag_cnt_cache[info.buf]
    local buf_cnt_save = vim.deepcopy(buf_cnt)
    for k, _ in pairs(buf_cnt) do
      buf_cnt[k] = 0
    end
    for _, diagnostic in ipairs(info.data.diagnostics) do
      buf_cnt[diagnostic.severity] = (buf_cnt[diagnostic.severity] or 0) + 1
    end
    for diag_nr = 1, 4 do
      diag_ws_cnt_cache[diag_nr] = (diag_ws_cnt_cache[diag_nr] or 0)
        - (buf_cnt_save[diag_nr] or 0)
        + (buf_cnt[diag_nr] or 0)
    end
  end,
})

vim.api.nvim_create_autocmd('BufDelete', {
  group = groupid,
  desc = 'Clear and update diagnostics cache for the status line.',
  callback = function(info)
    local buf = info.buf
    local diag_buf_cnt = diag_cnt_cache[buf]
    if not diag_buf_cnt then
      return
    end
    for diag_nr, diag_cnt in pairs(diag_buf_cnt) do
      diag_ws_cnt_cache[diag_nr] = diag_ws_cnt_cache[diag_nr] - diag_cnt
    end
    diag_cnt_cache[buf] = nil
    diag_str_cache = {}
  end,
})

---Get string representation of diagnostics for current buffer
---@return string
function statusline.diag()
  local buf = vim.api.nvim_get_current_buf()
  if diag_str_cache[buf] then
    return diag_str_cache[buf]
  end
  local str = ''
  local buf_cnt = diag_cnt_cache[buf] or {}
  for serverity_nr, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local cnt = buf_cnt[serverity_nr] or 0
    local ws_cnt = diag_ws_cnt_cache[serverity_nr] or 0
    if cnt + ws_cnt > 0 then
      local icon = signs_text_cache['DiagnosticSign' .. severity]
      local icon_hl = 'StatusLineDiagnostic' .. severity
      str = str
        .. (str == '' and '' or ' ')
        .. utils.stl.hl(icon, icon_hl)
        .. cnt
        .. '/'
        .. ws_cnt
    end
  end
  if str:find('%S') then
    str = str .. ' '
  end
  diag_str_cache[buf] = str
  return str
end

local spinner_end_keep = 2000 -- ms
local spinner_status_keep = 600 -- ms
local spinner_progress_keep = 80 -- ms
local spinner_icon_done = vim.trim(utils.static.icons.Ok)
local spinner_timer = vim.uv.new_timer()

local spinner_icons = {
  '⠋',
  '⠙',
  '⠹',
  '⠸',
  '⠼',
  '⠴',
  '⠦',
  '⠧',
  '⠇',
  '⠏',
}

---Id and additional info of language servers in progress
---@type table<integer, { name: string, timestamp: integer, type: 'begin'|'report'|'end' }>
local server_info_in_progress = {}

vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Update LSP progress info for the status line.',
  group = groupid,
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(
        spinner_progress_keep,
        spinner_progress_keep,
        vim.schedule_wrap(vim.cmd.redrawstatus)
      )
    end

    local id = info.data.client_id
    local now = vim.uv.now()
    server_info_in_progress[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      timestamp = now,
      type = info.data.result.value.kind,
    } -- Update LSP progress data
    -- Clear client message after a short time if no new message is received
    vim.defer_fn(function()
      -- No new report since the timer was set
      local last_timestamp = (server_info_in_progress[id] or {}).timestamp
      if not last_timestamp or last_timestamp == now then
        server_info_in_progress[id] = nil
        if vim.tbl_isempty(server_info_in_progress) and spinner_timer then
          spinner_timer:stop()
        end
        vim.cmd.redrawstatus()
      end
    end, spinner_end_keep)
  end,
})

---@return string
function statusline.lsp_progress()
  if vim.tbl_isempty(server_info_in_progress) then
    return ''
  end

  local buf = vim.api.nvim_get_current_buf()
  local server_ids = {}
  for id, _ in pairs(server_info_in_progress) do
    if vim.tbl_contains(vim.lsp.get_buffers_by_client_id(id), buf) then
      table.insert(server_ids, id)
    end
  end
  if vim.tbl_isempty(server_ids) then
    return ''
  end

  local now = vim.uv.now()
  ---@return boolean
  local function allow_changing_state()
    return not vim.b.spinner_state_changed
      or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  if
    #server_ids == 1
    and server_info_in_progress[server_ids[1]].type == 'end'
  then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done
    end
  else
    local spinner_icon_progress = spinner_icons[math.ceil(
      now / spinner_progress_keep
    ) % #spinner_icons + 1]
    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return string.format(
    '%s %s ',
    table.concat(
      vim.tbl_map(function(id)
        return server_info_in_progress[id].name
      end, server_ids),
      ', '
    ),
    vim.b.spinner_icon
  )
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align        = '%=',
  diag         = '%{%v:lua.statusline.diag()%}',
  fname        = ' %#StatusLineStrong#%{%&bt==#""?"%t":"%F"%}%* ',
  fname_nc     = ' %{%&bt==#""?"%t":"%F"%} ',
  info         = '%{%v:lua.statusline.info()%}',
  lsp_progress = '%{%v:lua.statusline.lsp_progress()%}',
  mode         = '%{%v:lua.statusline.mode()%}',
  padding      = '%#None#  %*',
  pos          = '%{%&ru?"%l:%c ":""%}',
  truncate     = '%<',
}
-- stylua: ignore end

local stl = table.concat({
  components.mode,
  components.fname,
  components.info,
  components.align,
  components.truncate,
  components.lsp_progress,
  components.diag,
  components.pos,
})

local stl_nc = table.concat({
  components.fname_nc,
  components.align,
  components.truncate,
  components.pos,
})

---Get statusline string
---@return string
function statusline.get()
  return vim.g.statusline_winid == vim.api.nvim_get_current_win() and stl
    or stl_nc
end

vim.api.nvim_create_autocmd(
  { 'FileChangedShellPost', 'DiagnosticChanged', 'LspProgress' },
  {
    group = groupid,
    command = 'redrawstatus',
  }
)

vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
  group = groupid,
  callback = function()
    ---@param hlgroup_name string
    ---@param attr table
    ---@return nil
    local function sethl(hlgroup_name, attr)
      attr.fg = attr.fg or 'StatusLine'
      attr.bg = attr.bg or 'StatusLine'
      utils.hl.set_default(0, hlgroup_name, attr)
    end
    -- stylua: ignore start
    sethl('StatusLineHeader', { bg = 'TabLine', bold = true })
    sethl('StatusLineHeaderModified', { fg = 'Special', bg = 'TabLine', bold = true })
    sethl('StatusLineStrong', { bold = true })
    sethl('StatusLineGitAdded', { fg = 'GitSignsAdd' })
    sethl('StatusLineGitChanged', { fg = 'GitSignsChange' })
    sethl('StatusLineGitRemoved', { fg = 'GitSignsDelete' })
    sethl('StatusLineDiagnosticError', { fg = 'DiagnosticSignError' })
    sethl('StatusLineDiagnosticHint', { fg = 'DiagnosticSignHint' })
    sethl('StatusLineDiagnosticInfo', { fg = 'DiagnosticSignInfo' })
    sethl('StatusLineDiagnosticWarn', { fg = 'DiagnosticSignWarn' })
    -- stylua: ignore end
  end,
})

vim.go.statusline = '%!v:lua.statusline.get()'
