local funcs = require('utils.funcs')
local icons = require('utils.static').icons.kinds
local bar = require('plugin.winbar.bar')

-- Valid treesitter types to get symbols from
local types = {
  'array',
  'boolean',
  'call',
  'class',
  'color',
  'constant',
  'constructor',
  'copilot',
  'enum',
  'enum_member',
  'event',
  'function',
  'interface',
  'keyword',
  'list',
  'log',
  'lsp',
  'macro',
  'method',
  'module',
  'namespace',
  'null',
  'number',
  'operator',
  'package',
  'property',
  'reference',
  'regex',
  'repeat',
  'scope',
  'snippet',
  'specifier',
  'string',
  'struct',
  'terminal',
  'type',
  'type_parameter',
  'unit',
  'value',
  'variable',
  'declaration',
  'field',
  'identifier',
  'object',
  'statement',
  'text',
}

---Get treesitter symbols from buffer
---@param buf integer buffer handler
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
        table.insert(
          symbols,
          1,
          bar.winbar_symbol_t:new({
            icon = icons[lsp_type],
            name = vim.trim(
              vim.treesitter
                .get_node_text(current_node, buf)
                :match('[%w%._%-!>]*%s*[%w%._%-!>]*%s*[%w%._%-!>]*')
                :gsub('\n.*', '')
            ),
            icon_hl = 'WinBarIconKind' .. lsp_type,
          })
        )
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
