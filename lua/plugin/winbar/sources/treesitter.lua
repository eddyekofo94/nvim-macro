local funcs = require('utils.funcs')
local icons = require('utils.static').icons.kinds
local bar = require('plugin.winbar.bar')

-- Valid treesitter types to get symbols from
local types = {
  'array',
  'boolean',
  'call',
  'class',
  'constant',
  'constructor',
  'enum',
  'enum_member',
  'event',
  'function',
  'interface',
  'keyword',
  'list',
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
  'repeat',
  'scope',
  'specifier',
  'string',
  'struct',
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
  local prev_type_rank = math.huge
  local current_node = vim.treesitter.get_node({
    bufnr = buf,
    pos = { cursor[1] - 1, cursor[2] },
  })
  while current_node do
    local ts_type = current_node:type()
    for type_rank, type in ipairs(types) do
      if ts_type:find(type, 1, true) then
        local lsp_type = funcs.string.snake_to_camel(type)
        local name = vim.trim(
          vim.treesitter
            .get_node_text(current_node, buf)
            :match(string.rep('[#~%w%._%->!]*', 4, '%s*'))
            :gsub('\n.*', '')
        )
        if
          vim.tbl_isempty(symbols)
          or symbols[1].name ~= name
          or vim.tbl_contains({
            'if',
            'for',
            'while',
            'do',
            'try',
            'catch',
            'finally',
            'switch',
            'case',
            'default',
          }, name)
        then
          table.insert(
            symbols,
            1,
            bar.winbar_symbol_t:new({
              icon = icons[lsp_type],
              name = name,
              icon_hl = 'WinBarIconKind' .. lsp_type,
            })
          )
          prev_type_rank = type_rank
          break
        elseif symbols[1].name == name and type_rank < prev_type_rank then
          symbols[1].icon = icons[lsp_type]
          symbols[1].icon_hl = 'WinBarIconKind' .. lsp_type
          prev_type_rank = type_rank
          break
        end
      end
    end
    current_node = current_node:parent()
  end
  return symbols
end

return {
  get_symbols = get_symbols,
}
