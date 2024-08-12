local M = {}
local types = require "cmp.types"
local lspkind = require "lspkind"

---Filter out unwanted entries
---@param entry cmp.Entry
---@param _ cmp.Context ignored
---@return boolean
function M.entry_filter(entry, _)
  return not vim.tbl_contains({
    "No matches found",
    "Searching...",
    "Workspace loading",
  }, entry.completion_item.label)
end

M.has_words_before = function()
  if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match "^%s*$" == nil
end

M.check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--- Get completion context, i.e., auto-import/target module location.
--- Depending on the LSP this information is stored in different parts of the
--- lsp.CompletionItem payload. The process to find them is very manual: log the payloads
--- And see where useful information is stored.
---@param completion lsp.CompletionItem
---@param source cmp.Source
---@see Astronvim, because i just discovered they're already doing this thing, too
--  https://github.com/AstroNvim/AstroNvim
function M.get_lsp_completion_context(completion, source)
  local ok, source_name = pcall(function()
    return source.source.client.config.name
  end)
  if not ok then
    return nil
  end
  if source_name == "tsserver" or source_name == "typescript-tools" then
    return completion.detail
  elseif source_name == "pyright" then
    if completion.labelDetails ~= nil then
      return completion.labelDetails.description
    end
  end
end

M.format = function(entry, vim_item)
  -- Set the highlight group for the Codeium source
  if entry.source.name == "codeium" then
    vim_item.kind_hl_group = "CmpItemKindCopilot"
  end

  -- Get the item with kind from the lspkind plugin
  local item_with_kind = require("lspkind").cmp_format {
    mode = "symbol_text",
    maxwidth = 50,
    symbol_map = source_mapping,
  }(entry, vim_item)

  item_with_kind.kind = lspkind.symbolic(item_with_kind.kind, { with_text = true })
  item_with_kind.menu = source_mapping[entry.source.name]
  item_with_kind.menu = vim.trim(item_with_kind.menu or "")
  item_with_kind.abbr = string.sub(item_with_kind.abbr, 1, item_with_kind.maxwidth)

  if entry.source.name == "cmp_tabnine" then
    if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
      item_with_kind.kind = " " .. lspkind.symbolic("Event", { with_text = false }) .. " TabNine"
      item_with_kind.menu = item_with_kind.menu .. entry.completion_item.data.detail
    else
      item_with_kind.kind = " " .. lspkind.symbolic("Event", { with_text = false }) .. " TabNine"
      item_with_kind.menu = item_with_kind.menu .. " TBN"
    end
  end

  local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
  if completion_context ~= nil and completion_context ~= "" then
    item_with_kind.menu = item_with_kind.menu .. [[ -> ]] .. completion_context
  end

  if string.find(vim_item.kind, "Color") then
    -- Override for plugin purposes
    vim_item.kind = "Color"
    local tailwind_item = require("cmp-tailwind-colors").format(entry, vim_item)
    item_with_kind.menu = lspkind.symbolic("Color", { with_text = false }) .. " Color"
    item_with_kind.kind = " " .. tailwind_item.kind
  end

  return item_with_kind
end

---Filter out unwanted entries for fuzzy_path source
---@param entry cmp.Entry
---@param context cmp.Context
function M.entry_filter_fuzzy_path(entry, context)
  return M.entry_filter(entry, context)
    -- Don't show fuzzy-path entries in markdown/tex mathzone
    and not (
      vim.g.loaded_vimtex == 1
      and (vim.bo.ft == "markdown" or vim.bo.ft == "tex")
      and vim.api.nvim_eval "vimtex#syntax#in_mathzone()" == 1
    )
end

-- TODO:  fix this instead of using
-- "tzachar/cmp-fuzzy-path"
---Options for fuzzy_path source
M.fuzzy_path_option = {
  fd_cmd = {
    "fd",
    "-p",
    "-H",
    "-L",
    "-td",
    "-tf",
    "-tl",
    "-d4",
    "--mount",
    "-c=never",
    "-E=*$*",
    "-E=*%*",
    "-E=*.bkp",
    "-E=*.bz2",
    "-E=*.db",
    "-E=*.directory",
    "-E=*.dll",
    "-E=*.doc",
    "-E=*.docx",
    "-E=*.drawio",
    "-E=*.gif",
    "-E=*.git/",
    "-E=*.gz",
    "-E=*.ico",
    "-E=*.iso",
    "-E=*.jar",
    "-E=*.jpeg",
    "-E=*.jpg",
    "-E=*.mp3",
    "-E=*.mp4",
    "-E=*.o",
    "-E=*.otf",
    "-E=*.out",
    "-E=*.pdf",
    "-E=*.pickle",
    "-E=*.png",
    "-E=*.ppt",
    "-E=*.pptx",
    "-E=*.pyc",
    "-E=*.rar",
    "-E=*.so",
    "-E=*.svg",
    "-E=*.tar",
    "-E=*.ttf",
    "-E=*.venv/",
    "-E=*.xls",
    "-E=*.xlsx",
    "-E=*.zip",
    "-E=*Cache*/",
    "-E=*\\~",
    "-E=*cache*/",
    "-E=.*Cache*/",
    "-E=.*cache*/",
    "-E=.*wine/",
    "-E=.cargo/",
    "-E=.conda/",
    "-E=.dot/",
    "-E=.fonts/",
    "-E=.ipython/",
    "-E=.java/",
    "-E=.jupyter/",
    "-E=.luarocks/",
    "-E=.mozilla/",
    "-E=.npm/",
    "-E=.nvm/",
    "-E=.steam*/",
    "-E=.thunderbird/",
    "-E=.tmp/",
    "-E=__pycache__/",
    "-E=dosdevices/",
    "-E=events.out.tfevents.*",
    "-E=node_modules/",
    "-E=vendor/",
    "-E=venv/",
  },
}

function M.limit_lsp_types(entry, ctx)
  local kind = entry:get_kind()
  local line = ctx.cursor.line
  local col = ctx.cursor.col
  local char_before_cursor = string.sub(line, col - 1, col - 1)
  local char_after_dot = string.sub(line, col, col)

  if char_before_cursor == "." and char_after_dot:match "[a-zA-Z]" then
    if
      kind == types.lsp.CompletionItemKind.Method
      or kind == types.lsp.CompletionItemKind.Field
      or kind == types.lsp.CompletionItemKind.Property
    then
      return true
    else
      return false
    end
  elseif string.match(line, "^%s+%w+$") then
    if kind == types.lsp.CompletionItemKind.Function or kind == types.lsp.CompletionItemKind.Variable then
      return true
    else
      return false
    end
  end

  return true
end

return M
