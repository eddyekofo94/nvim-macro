local funcs = require('utils.funcs')
local static = require('utils.static')

-- Valid treesitter types to get symbols from
local types = vim.tbl_map(function(type_name)
  return funcs.string.camel_to_snake(type_name)
end, vim.tbl_keys(static.icons))

---Get treesitter symbols from buffer
---@param buf number buffer handler
---@param cursor integer[] cursor position
---@return winbar_symbol_t[] symbols winbar symbols
local function get_symbols(buf, cursor)
  local parsers_ok, parsers = pcall(require, 'nvim-treesitter.parsers')
  if not parsers_ok or not parsers.has_parser() then
    return {}
  end

  local symbols = {}
  local current_node = vim.treesitter.get_node({
    bufnr = buf,
    pos = { cursor[1] - 1, cursor[2] },
  })
  while current_node do
    local ts_type = current_node:type()
    for _, type in ipairs(types) do
      if ts_type:find(type, 1, true) then
        local lsp_type = funcs.string.snake_to_camel(type)
        table.insert(symbols, 1, {
          icon = static.icons[lsp_type],
          name = vim.trim(
            vim.treesitter
              .get_node_text(current_node, buf)
              :match('[%w%._]*%s*[%w%._]*%s*[%w%._]*')
              :gsub('\n.*', '')
          ),
          icon_hl = 'WinBarIconKind' .. lsp_type,
        })
        break
      end
    end
    -- Eliminate duplicate symbols
    local prev_node = current_node
    while current_node and current_node:type() == prev_node:type() do
      prev_node = current_node
      current_node = current_node:parent()
    end
  end
  return symbols
end

return {
  get_symbols = get_symbols,
}
