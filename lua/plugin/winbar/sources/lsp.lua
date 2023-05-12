local static = require('utils.static')
local groupid = vim.api.nvim_create_augroup('WinBarLsp', {})
local lsp_buf_symbols = {}
local initialized = false

---@alias lsp_client_t table

---@class lsp_range_t
---@field start {line: integer, character: integer}
---@field end {line: integer, character: integer}

---@class lsp_location_t
---@field uri string
---@field range lsp_range_t

---@class lsp_symbol_t
---@field name string
---@field kind integer
---@field tags table
---@field deprecated boolean
---@field detail? string
---@field location? lsp_location_t
---@field range? lsp_range_t
---@field selectionRange? lsp_range_t
---@field children? lsp_symbol_t[]

-- Map symbol number to symbol kind
-- stylua: ignore start
local symbol_kind_names = {
  [1]  = 'File',
  [2]  = 'Module',
  [3]  = 'Namespace',
  [4]  = 'Package',
  [5]  = 'Class',
  [6]  = 'Method',
  [7]  = 'Property',
  [8]  = 'Field',
  [9]  = 'Constructor',
  [10] = 'Enum',
  [11] = 'Interface',
  [12] = 'Function',
  [13] = 'Variable',
  [14] = 'Constant',
  [15] = 'String',
  [16] = 'Number',
  [17] = 'Boolean',
  [18] = 'Array',
  [19] = 'Object',
  [20] = 'Keyword',
  [21] = 'Null',
  [22] = 'EnumMember',
  [23] = 'Struct',
  [24] = 'Event',
  [25] = 'Operator',
  [26] = 'TypeParameter',
}
-- stylua: ignore end

---Return type of the symbol table
---@param symbols lsp_symbol_t[] symbol table
---@return string? symbol type
local function symbol_type(symbols)
  if symbols[1] and symbols[1].location then
    return 'SymbolInformation'
  elseif symbols[1] and symbols[1].range then
    return 'DocumentSymbol'
  end
end

---Check if cursor is in range
---@param cursor integer[] cursor position (line, character); (1, 0)-based
---@param range lsp_range_t 0-based range
---@return boolean
local function cursor_in_range(cursor, range)
  local cursor0 = { cursor[1] - 1, cursor[2] }
  -- stylua: ignore start
  return (
    cursor0[1] > range.start.line
    or (cursor0[1] == range.start.line
        and cursor0[2] >= range.start.character)
  )
    and (
      cursor0[1] < range['end'].line
      or (cursor0[1] == range['end'].line
          and cursor0[2] <= range['end'].character)
    )
  -- stylua: ignore end
end

---Parse LSP SymbolInformation[] into a list of winbar symbols
---Each SymbolInformation in the list is sorted by the start position of its
---range, so just need to traverse the list in order and add each symbol that
---contains the cursor to the winbar_symbols list.
---Side effect: change winbar_symbols
---LSP Specification document: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
---@param lsp_symbols lsp_symbol_t[] LSP symbols of type SymbolInformation
---@param winbar_symbols winbar_symbol_t[] (reference to) winbar symbols
---@param cursor integer[] cursor position
local function parse_symbol_information(lsp_symbols, winbar_symbols, cursor)
  for _, symbol in ipairs(lsp_symbols) do
    if
      symbol.location
      and symbol.location.range
      and cursor_in_range(cursor, symbol.location.range)
    then
      table.insert(winbar_symbols, {
        name = symbol.name,
        icon = static.icons[symbol_kind_names[symbol.kind]],
        icon_hl = 'WinBarIconKind' .. symbol_kind_names[symbol.kind],
      })
    end
  end
end

---Parse LSP DocumentSymbol[] into a list of winbar symbols
---Side effect: change winbar_symbols
---LSP Specification document: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
---@param lsp_symbols lsp_symbol_t[] LSP symbols of type DocumentSymbol
---@param winbar_symbols winbar_symbol_t[] (reference to) winbar symbols
---@param cursor integer[] cursor position
local function parse_document_symbol(lsp_symbols, winbar_symbols, cursor)
  for _, symbol in ipairs(lsp_symbols) do
    if symbol.range and cursor_in_range(cursor, symbol.range) then
      table.insert(winbar_symbols, {
        name = symbol.name,
        icon = static.icons[symbol_kind_names[symbol.kind]],
        icon_hl = 'WinBarIconKind' .. symbol_kind_names[symbol.kind],
      })
      if symbol.children then
        parse_document_symbol(symbol.children, winbar_symbols, cursor)
      end
      return
    end
  end
end

---Parse LSP symbols into a list of winbar symbols
---@param symbols lsp_symbol_t[] LSP symbols
---@return winbar_symbol_t[] symbol_path winbar symbols
local function parse_symbols(symbols)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local symbol_path = {}
  if symbol_type(symbols) == 'SymbolInformation' then
    parse_symbol_information(symbols, symbol_path, cursor)
  elseif symbol_type(symbols) == 'DocumentSymbol' then
    parse_document_symbol(symbols, symbol_path, cursor)
  end
  return symbol_path
end

local TTL = 60
---Get LSP symbols from an LSP client
---Side effect: update symbol_list
---@param buf number buffer handler
---@param client lsp_client_t LSP client
---@param symbol_list lsp_symbol_t[] (reference to) symbols
---@param ttl number? limit the number of recursive requests
local function update_symbols(buf, client, symbol_list, ttl)
  ttl = ttl or TTL
  if ttl <= 0 or not vim.b[buf].winbar_lsp_attached then
    return
  end
  local textdocument_params = vim.lsp.util.make_text_document_params(buf)
  client.request(
    'textDocument/documentSymbol',
    { textDocument = textdocument_params },
    function(err, symbols, _)
      if err or not symbols then
        vim.defer_fn(function()
          update_symbols(buf, client, symbol_list, ttl - 1)
        end, 1000)
      elseif symbols then -- Update symbol_list
        while not vim.tbl_isempty(symbol_list) do
          table.remove(symbol_list)
        end
        vim.list_extend(symbol_list, symbols)
        vim.cmd.redrawstatus() -- Redraw winbar after updating symbol_list
      end
    end,
    buf
  )
end

---Attach LSP symbol getter to buffer
---@param buf number buffer handler
local function attach(buf)
  if vim.b[buf].winbar_lsp_attached then
    return
  end
  local function _update()
    local client = vim.tbl_filter(function(client)
      return client.supports_method('textDocument/documentSymbol')
    end, vim.lsp.get_active_clients({ bufnr = buf }))[1]
    lsp_buf_symbols[buf] = lsp_buf_symbols[buf] or {}
    update_symbols(buf, client, lsp_buf_symbols[buf])
  end
  vim.b[buf].winbar_lsp_attached = vim.api.nvim_create_autocmd(
    { 'TextChanged', 'TextChangedI' },
    {
      group = groupid,
      buffer = buf,
      callback = _update,
    }
  )
  _update()
end

---Detach LSP symbol getter from buffer
---@param buf number buffer handler
local function detach(buf)
  if vim.b[buf].winbar_lsp_attached then
    vim.api.nvim_del_autocmd(vim.b[buf].winbar_lsp_attached)
    vim.b[buf].winbar_lsp_attached = nil
  end
end

---Initialize lsp source
---@return nil
local function init()
  if initialized then
    return
  end
  initialized = true
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local clients = vim.tbl_filter(function(client)
      return client.supports_method('textDocument/documentSymbol')
    end, vim.lsp.get_active_clients({ bufnr = buf }))
    if not vim.tbl_isempty(clients) then
      attach(buf)
    end
  end
  vim.api.nvim_create_autocmd({ 'LspAttach' }, {
    desc = 'Attach LSP symbol getter to buffer when an LS that supports documentSymbol attaches.',
    group = groupid,
    callback = function(info)
      local client = vim.lsp.get_client_by_id(info.data.client_id)
      if client.supports_method('textDocument/documentSymbol') then
        attach(info.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'LspDetach' }, {
    desc = 'Detach LSP symbol getter from buffer when no LS supporting documentSymbol is attached.',
    group = groupid,
    callback = function(info)
      local clients = vim.tbl_filter(function(client)
        return client.supports_method('textDocument/documentSymbol')
      end, vim.lsp.get_active_clients({ bufnr = info.buf }))
      if vim.tbl_isempty(clients) then
        detach(info.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufUnload', 'BufWipeOut' }, {
    desc = 'Detach LSP symbol getter from buffer on buffer delete/unload/wipeout.',
    group = groupid,
    callback = function(info)
      detach(info.buf)
    end,
  })
end

---Get winbar symbols from buffer
---@param buf number buffer handler
---@return winbar_symbol_t[] symbols winbar symbols
local function get_symbols(buf)
  if not initialized then
    init()
  end
  return parse_symbols(lsp_buf_symbols[buf] or {})
end

return {
  get_symbols = get_symbols,
}
