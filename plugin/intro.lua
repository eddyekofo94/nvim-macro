-- Disable default intro message
vim.opt.shortmess:append "I"

if vim.fn.argc() > 0 or not vim.g.has_ui then
  return
end

-- Set eventignore to avoid triggering plugin lazy-loading handlers
local eventignore = vim.go.eventignore
vim.go.eventignore = "all"

local logo = true and "M Λ C R O" or "M A C R O"

---@class intro_chunk_t
---@field text string
---@field hl string
---@field len integer? byte-indexed text length
---@field width integer? display width of text

---@class intro_line_t
---@field chunks intro_chunk_t[]
---@field text string?
---@field width integer?
---@field offset integer?

---Lines of text and highlight groups to display as intro message
---@type intro_line_t[]
local lines = {
  {
    chunks = {
      { text = string.format("Neovim :: %s", logo), hl = "Normal" },
      { text = " - Editing made simple", hl = "NonText" },
    },
  },
  {
    chunks = {
      {
        text = string.format("Copyright (c) 2023 - %s developers", logo),
        hl = "NonText",
      },
    },
  },
}

---Window configuration for the intro message floating window
---@type vim.api.keyset.win_config
local win_config = {
  width = 0,
  height = #lines,
  relative = "editor",
  style = "minimal",
  focusable = false,
  noautocmd = true,
  zindex = 1,
}

---Calculate the width, offset, concatenated text, etc.
for _, line in ipairs(lines) do
  line.text = ""
  line.width = 0
  for _, chunk in ipairs(line.chunks) do
    chunk.len = #chunk.text
    chunk.width = vim.fn.strdisplaywidth(chunk.text)
    line.text = line.text .. chunk.text
    line.width = line.width + chunk.width
  end
  if line.width > win_config.width then
    win_config.width = line.width
  end
end

for _, line in ipairs(lines) do
  line.offset = math.floor((win_config.width - line.width) / 2)
end

-- Decide the row and col offset of the floating window,
-- return if no enough space
win_config.row = math.floor((vim.go.lines - vim.go.ch - win_config.height) / 2)
win_config.col = math.floor((vim.go.columns - win_config.width) / 2)
if win_config.row < 4 or win_config.col < 8 then
  -- Restore &eventignore before exit
  vim.go.eventignore = eventignore
  return
end

-- Create the scratch buffer to display the intro message
local buf = vim.api.nvim_create_buf(false, true)
vim.bo[buf].bufhidden = "wipe"
vim.bo[buf].buftype = "nofile"
vim.bo[buf].swapfile = false
vim.api.nvim_buf_set_lines(
  buf,
  0,
  -1,
  false,
  vim.tbl_map(function(line)
    return string.rep(" ", line.offset) .. line.text
  end, lines)
)

-- Apply highlight groups
local ns = vim.api.nvim_create_namespace "NvimIntro"
for linenr, line in ipairs(lines) do
  local chunk_offset = line.offset
  for _, chunk in ipairs(line.chunks) do
    vim.highlight.range(buf, ns, chunk.hl, { linenr - 1, chunk_offset }, { linenr - 1, chunk_offset + chunk.len }, {})
    chunk_offset = chunk_offset + chunk.len
  end
end

-- Open the window to show the intro message
local win = vim.api.nvim_open_win(buf, false, win_config)
vim.wo[win].winhl = "NormalFloat:Normal,Search:,Incsearch:"

-- Clear the intro when the user does something
vim.api.nvim_create_autocmd({
  "BufModifiedSet",
  "BufReadPre",
  "CursorMoved",
  "StdinReadPre",
  "InsertEnter",
  "TermOpen",
  "TextChanged",
  "VimResized",
  "WinEnter",
}, {
  once = true,
  group = vim.api.nvim_create_augroup("NvimIntro", {}),
  callback = function(info)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    vim.api.nvim_del_augroup_by_id(info.group)
    return true
  end,
})

-- Restore &eventignore before exit
vim.go.eventignore = eventignore
