local funcs = require('utils.funcs')
local icons = require('utils.static').icons.kinds
local bar = require('plugin.winbar.bar')

-- Valid treesitter types to get symbols from
local types = {
  'array',
  'boolean',
  'break_statement',
  'call',
  'case_statement',
  'class',
  'constant',
  'constructor',
  'continue_statement',
  'delete',
  'do_statement',
  'enum',
  'enum_member',
  'event',
  'for_statement',
  'function',
  'if_statement',
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
  'switch_statement',
  'type',
  'type_parameter',
  'unit',
  'value',
  'variable',
  'while_statement',
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
  if not vim.treesitter.highlighter.active[buf] then
    return {}
  end

  local symbols = {}
  local prev_type_rank = math.huge
  local prev_row = math.huge
  local current_node = vim.treesitter.get_node({
    bufnr = buf,
    pos = { cursor[1] - 1, cursor[2] },
  })
  while current_node do
    local ts_type = current_node:type()
    local name = vim.trim(
      vim.treesitter
        .get_node_text(current_node, buf)
        :match(string.rep('[#~%w%._%->!]*', 4, '%s*'))
        :gsub('\n.*', '')
    )
    local range = { current_node:range() } ---@type Range4
    local start_row = range[1]
    local end_row = range[3]
    if name ~= '' and not (start_row == 0 and end_row == vim.fn.line('$')) then
      for type_rank, type in ipairs(types) do
        if ts_type:find(type, 1, true) then
          local lsp_type = funcs.string.snake_to_camel(type)
          if
            vim.tbl_isempty(symbols)
            or symbols[1].name ~= name
            or start_row < prev_row
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
            prev_row = start_row
            break
          elseif type_rank < prev_type_rank then
            symbols[1].icon = icons[lsp_type]
            symbols[1].icon_hl = 'WinBarIconKind' .. lsp_type
            prev_type_rank = type_rank
            prev_row = start_row
            break
          end
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
