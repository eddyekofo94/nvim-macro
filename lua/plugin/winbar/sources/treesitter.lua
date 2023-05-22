local funcs = require('utils.funcs')
local utils = require('plugin.winbar.sources.utils')
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

---Get short name of treesitter symbols in buffer buf
---@param node TSNode
---@param buf integer buffer handler
local function get_node_short_name(node, buf)
  return vim.trim(
    vim.treesitter
      .get_node_text(node, buf)
      :match(string.rep('[#~%w%._%->!]*', 4, '%s*'))
      :gsub('\n.*', '')
  )
end

---Get valid treesitter node type name
---@param node TSNode
---@return string type_name
---@return integer rank type rank
local function get_node_short_type(node)
  local ts_type = node:type()
  for i, type in ipairs(types) do
    if ts_type:find(type, 1, true) then
      return type, i
    end
  end
  return 'statement', math.huge
end

---Get treesitter node children
---@param node TSNode
---@return TSNode[] children
local function get_node_children(node)
  local children = {}
  for child in node:iter_children() do
    table.insert(children, child)
  end
  return children
end

---Convert TSNode to winbar symbol tree format
---@param ts_node TSNode
---@param buf integer buffer handler
---@return winbar_symbol_tree_t
local function convert(ts_node, buf)
  local range = { ts_node:range() }
  local converted = setmetatable({
    node = ts_node,
    name = get_node_short_name(ts_node, buf),
    kind = funcs.string.snake_to_camel(get_node_short_type(ts_node)),
    range = {
      start = {
        line = range[1],
        character = range[2],
      },
      ['end'] = {
        line = range[3],
        character = range[4],
      },
    },
  }, {
    __index = function(self, k)
      if k == 'children' then
        self.children = vim.tbl_map(function(child)
          return utils.winbar_source_symbol_t:new(convert, child, buf)
        end, get_node_children(ts_node))
        return self.children
      end
    end,
  })
  return converted
end

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
    local name = get_node_short_name(current_node, buf)
    local range = { current_node:range() } ---@type Range4
    local start_row = range[1]
    local end_row = range[3]
    if name ~= '' and not (start_row == 0 and end_row == vim.fn.line('$')) then
      local type, type_rank = get_node_short_type(current_node)
      local lsp_type = funcs.string.snake_to_camel(type)
      if
        vim.tbl_isempty(symbols)
        or symbols[1].name ~= name
        or start_row < prev_row
      then
        local siblings = get_node_children(current_node:parent())
        local idx = 0
        for i, sibling in ipairs(siblings) do
          if sibling:id() == current_node:id() then
            idx = i
            break
          end
        end
        table.insert(
          symbols,
          1,
          utils.winbar_source_symbol_t
            :new(convert, current_node, buf)
            :to_winbar_symbol({
              data = {
                menu = {
                  idx = idx,
                  symbols_list = vim.tbl_map(function(child)
                    return utils.winbar_source_symbol_t:new(
                      convert,
                      child,
                      buf
                    )
                  end, siblings),
                },
              },
            })
        )
        prev_type_rank = type_rank
        prev_row = start_row
      elseif type_rank < prev_type_rank then
        symbols[1].icon = icons[lsp_type]
        symbols[1].icon_hl = 'WinBarIconKind' .. lsp_type
        prev_type_rank = type_rank
        prev_row = start_row
      end
    end
    current_node = current_node:parent()
  end
  return symbols
end

return {
  get_symbols = get_symbols,
}
