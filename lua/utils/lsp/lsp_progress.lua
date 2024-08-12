local M = {}
local utils = require "utils"
local groupid = vim.api.nvim_create_augroup("StatusLine", {})

local spinner_end_keep = 2000 -- ms
local spinner_status_keep = 600 -- ms
local spinner_progress_keep = 80 -- ms
local spinner_timer = vim.uv.new_timer()
local spinner_icon_done = vim.trim(utils.static.icons.Ok)

-- local spinner_icons = { " ", " ", " ", "󰺕 ", " ", " " }
local spinner_icons = {
  "⠋",
  "⠙",
  "⠹",
  "⠸",
  "⠼",
  "⠴",
  "⠦",
  "⠧",
  "⠇",
  "⠏",
}

---Id and additional info of language servers in progress
---@type table<integer, { name: string, timestamp: integer, type: 'begin'|'report'|'end' }>
local server_info_in_progress = {}

vim.api.nvim_create_autocmd("LspProgress", {
  desc = "Update LSP progress info for the status line.",
  group = groupid,
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(spinner_progress_keep, spinner_progress_keep, vim.schedule_wrap(vim.cmd.redrawstatus))
    end

    local id = info.data.client_id
    local now = vim.uv.now()
    server_info_in_progress[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      timestamp = now,
      type = info.data.result and info.data.result.value.kind,
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
function M.lsp_progress()
  if vim.tbl_isempty(server_info_in_progress) then
    return ""
  end

  local buf = vim.api.nvim_get_current_buf()
  local server_ids = {}
  for id, _ in pairs(server_info_in_progress) do
    if vim.tbl_contains(vim.lsp.get_buffers_by_client_id(id), buf) then
      table.insert(server_ids, id)
    end
  end
  if vim.tbl_isempty(server_ids) then
    return ""
  end

  local now = vim.uv.now()

  ---@return boolean
  local function allow_changing_state()
    return not vim.b.spinner_state_changed or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  if #server_ids == 1 and server_info_in_progress[server_ids[1]].type == "end" then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done
    end
  else
    local spinner_icon_progress = spinner_icons[math.ceil(now / spinner_progress_keep) % #spinner_icons + 1]
    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return string.format(
    "%s %s ",
    table.concat(
      vim.tbl_map(function(id)
        return server_info_in_progress[id].name
      end, server_ids),
      ", "
    ),
    vim.b.spinner_icon
  )
end

return M
