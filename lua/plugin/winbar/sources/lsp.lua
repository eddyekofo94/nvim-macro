local bar = require('plugin.winbar.bar')
local static = require('utils.static')
local utils = require('plugin.winbar.sources.utils')
local groupid = vim.api.nvim_create_augroup('WinBarLsp', {})
local initialized = false

---@type table<integer, lsp_document_symbol_t[]>
local lsp_buf_symbols = {}
setmetatable(lsp_buf_symbols, {
  __index = function(_, k)
    lsp_buf_symbols[k] = {}
    return lsp_buf_symbols[k]
  end,
})

---@alias lsp_client_t table

---@class lsp_range_t
---@field start {line: integer, character: integer}
---@field end {line: integer, character: integer}

---@class lsp_location_t
---@field uri string
---@field range lsp_range_t

---@class lsp_document_symbol_t
---@field name string
---@field kind integer
---@field tags? table
---@field deprecated? boolean
---@field detail? string
---@field range? lsp_range_t
---@field selectionRange? lsp_range_t
---@field children? lsp_document_symbol_t[]

---@class lsp_symbol_information_t
---@field name string
---@field kind integer
---@field tags? table
---@field deprecated? boolean
---@field location? lsp_location_t
---@field containerName? string

---@alias lsp_symbol_t lsp_document_symbol_t|lsp_symbol_information_t

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

---Unify LSP SymbolInformation into winbar symbol tree structure
---@param lsp_symbol_information lsp_symbol_information_t LSP SymbolInformation
---@param idx integer index of the symbol in SymbolInformation[]
---@param symbols lsp_symbol_information_t[] SymbolInformation[]
---@return winbar_symbol_tree_t
local function unify_symbol_information(lsp_symbol_information, idx, symbols)
  return setmetatable({
    name = lsp_symbol_information.name,
    kind = symbol_kind_names[lsp_symbol_information.kind],
    range = lsp_symbol_information.location.range,
  }, {
    __index = function(self, k)
      if k == 'children' then
        local children = {}
        for symbol in vim.iter(symbols):skip(idx) do
          local start_pos = symbol.location.range.start
          local end_pos = symbol.location.range['end']
          start_pos = { start_pos.line + 1, start_pos.character }
          end_pos = { end_pos.line + 1, end_pos.character }
          if
            cursor_in_range(start_pos, self.range)
            and cursor_in_range(end_pos, self.range)
          then
            table.insert(children, unify_symbol_information(symbol))
          else
            break
          end
        end
        if not vim.tbl_isempty(children) then
          self.children = children
          return children
        end
        self.children = false
      end
    end,
  })
end

---Convert LSP SymbolInformation[] into a list of winbar symbols
---Each SymbolInformation in the list is sorted by the start position of its
---range, so just need to traverse the list in order and add each symbol that
---contains the cursor to the winbar_symbols list.
---Side effect: change winbar_symbols
---LSP Specification document: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
---@param lsp_symbols lsp_symbol_information_t[]
---@param winbar_symbols winbar_symbol_t[] (reference to) winbar symbols
---@param cursor integer[] cursor position
local function convert_symbol_information_list(
  lsp_symbols,
  winbar_symbols,
  cursor
)
  for _, symbol in ipairs(lsp_symbols) do
    if cursor_in_range(cursor, symbol.location.range) then
      table.insert(
        winbar_symbols,
        bar.winbar_symbol_t:new({
          name = symbol.name,
          icon = static.icons.kinds[symbol_kind_names[symbol.kind]],
          icon_hl = 'WinBarIconKind' .. symbol_kind_names[symbol.kind],
        })
      )
    end
  end
end

---Unify LSP DocumentSymbol into winbar symbol tree structure
---@param document_symbol lsp_document_symbol_t LSP DocumentSymbol
---@return winbar_symbol_tree_t
local function unify_document_symbol(document_symbol)
  return setmetatable({
    name = document_symbol.name,
    kind = symbol_kind_names[document_symbol.kind],
    range = document_symbol.range,
  }, {
    __index = function(self, k)
      if k == 'children' then
        if not document_symbol.children then
          return nil
        end
        ---@type winbar_symbol_tree_t[]
        self.children = vim.tbl_map(function(child)
          return utils.winbar_symbol_tree_t:new(unify_document_symbol, child)
        end, document_symbol.children)
        return self.children
      end
    end,
  })
end

---Convert LSP DocumentSymbol[] into a list of winbar symbols
---Side effect: change winbar_symbols
---LSP Specification document: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/
---@param lsp_symbols lsp_document_symbol_t[]
---@param winbar_symbols winbar_symbol_t[] (reference to) winbar symbols
---@param cursor integer[] cursor position
local function convert_document_symbol_list(
  lsp_symbols,
  winbar_symbols,
  cursor
)
  -- Parse in reverse order so that the symbol with the largest start position
  -- is preferred
  for idx, symbol in vim.iter(lsp_symbols):enumerate():rev() do
    if cursor_in_range(cursor, symbol.range) then
      table.insert(
        winbar_symbols,
        utils.winbar_symbol_tree_t
          :new(unify_document_symbol, symbol)
          :to_winbar_symbol({
            data = {
              menu = {
                idx = idx,
                symbols_list = vim.tbl_map(function(sibling)
                  return utils.winbar_symbol_tree_t:new(
                    unify_document_symbol,
                    sibling
                  )
                end, lsp_symbols),
              },
            },
          })
      )
      if symbol.children then
        convert_document_symbol_list(symbol.children, winbar_symbols, cursor)
      end
      return
    end
  end
end

---Convert LSP symbols into a list of winbar symbols
---@param symbols lsp_symbol_t[] LSP symbols
---@param cursor integer[] cursor position
---@return winbar_symbol_t[] symbol_path winbar symbols
local function convert(symbols, cursor)
  local symbol_path = {}
  if symbol_type(symbols) == 'SymbolInformation' then
    convert_symbol_information_list(symbols, symbol_path, cursor)
  elseif symbol_type(symbols) == 'DocumentSymbol' then
    convert_document_symbol_list(symbols, symbol_path, cursor)
  end
  return symbol_path
end

---Update LSP symbols from an LSP client
---Side effect: update symbol_list
---@param buf integer buffer handler
---@param client lsp_client_t LSP client
---@param ttl integer? limit the number of recursive requests, default 60
local function update_symbols(buf, client, ttl)
  ttl = ttl or 60
  if
    ttl <= 0
    or not vim.api.nvim_buf_is_valid(buf)
    or not vim.b[buf].winbar_lsp_attached
  then
    lsp_buf_symbols[buf] = nil
    return
  end
  local textdocument_params = vim.lsp.util.make_text_document_params(buf)
  client.request(
    'textDocument/documentSymbol',
    { textDocument = textdocument_params },
    function(err, symbols, _)
      if err or not symbols or vim.tbl_isempty(symbols) then
        vim.defer_fn(function()
          update_symbols(buf, client, ttl - 1)
        end, 1000)
      else -- Update symbol_list
        lsp_buf_symbols[buf] = symbols
        for _, winbar in pairs(_G.winbar.bars[buf]) do
          winbar:update() -- Redraw winbar after updating symbols
        end
      end
    end,
    buf
  )
end

---Attach LSP symbol getter to buffer
---@param buf integer buffer handler
local function attach(buf)
  if vim.b[buf].winbar_lsp_attached then
    return
  end
  local function _update()
    local client = vim.tbl_filter(function(client)
      return client.supports_method('textDocument/documentSymbol')
    end, vim.lsp.get_active_clients({ bufnr = buf }))[1]
    update_symbols(buf, client)
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
---@param buf integer buffer handler
local function detach(buf)
  if vim.b[buf].winbar_lsp_attached then
    vim.api.nvim_del_autocmd(vim.b[buf].winbar_lsp_attached)
    vim.b[buf].winbar_lsp_attached = nil
    lsp_buf_symbols[buf] = nil
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
      if
        vim.tbl_isempty(vim.tbl_filter(function(client)
          return client.supports_method('textDocument/documentSymbol')
            and client.id ~= info.data.client_id
        end, vim.lsp.get_active_clients({ bufnr = info.buf })))
      then
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

---Get winbar symbols from buffer according to cursor position
---@param buf integer buffer handler
---@param cursor integer[] cursor position
---@return winbar_symbol_t[] symbols winbar symbols
local function get_symbols(buf, cursor)
  if not initialized then
    init()
  end
  return convert(lsp_buf_symbols[buf], cursor)
end

return {
  get_symbols = get_symbols,
}
