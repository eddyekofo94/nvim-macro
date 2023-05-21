local bar = require('plugin.winbar.bar')
local menu = require('plugin.winbar.menu')
local static = require('utils.static')
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

---Convert an LSP DocumentSymbol into a winbar symbol
---@param symbol lsp_document_symbol_t LSP DocumentSymbol
---@param opts winbar_symbol_t? winbar symbol options to override
---@return winbar_symbol_t
local function convert_document_symbol(symbol, opts)
  return bar.winbar_symbol_t:new(vim.tbl_deep_extend('force', {
    name = symbol.name,
    icon = static.icons.kinds[symbol_kind_names[symbol.kind]],
    icon_hl = 'WinBarIconKind' .. symbol_kind_names[symbol.kind],
    data = {
      lsp = {
        symbol = symbol,
      },
    },
    on_click = function(self, _, _, _, _)
      if
        not self.data.lsp.symbols_list
        or vim.tbl_isempty(self.data.lsp.symbols_list)
      then
        return
      end
      -- Toggle menu on click, create one if not exist
      if not self.menu then
        ---Entries of the menu
        ---@type winbar_menu_entry_t[]
        local entries = {}
        for _, sibling in ipairs(self.data.lsp.symbols_list) do
          table.insert(
            entries,
            menu.winbar_menu_entry_t:new({
              components = {
                -- Indicator to show if the symbol has children
                convert_document_symbol(sibling, {
                  name = '',
                  icon = sibling.children and static.icons.ui.AngleRight
                    or string.rep(
                      ' ',
                      vim.fn.strdisplaywidth(static.icons.ui.AngleRight)
                    ),
                  icon_hl = 'WinBarIconSeparator',
                  data = {
                    lsp = {
                      symbols_list = sibling.children,
                    },
                  },
                }),
                -- Icon and texts for the LSP symbol
                convert_document_symbol(sibling, {
                  ---Goto the location of the symbol on click
                  ---@param this winbar_symbol_t
                  on_click = function(this, _, _, _, _)
                    local dest_pos = this.data.lsp.symbol.range.start
                    local current_menu = this.entry.menu
                    local dest_win = current_menu.win
                    local menus_to_close = {}
                    while current_menu do
                      table.insert(menus_to_close, current_menu)
                      dest_win = current_menu.prev_win
                      current_menu = _G.winbar.menus[dest_win]
                    end
                    vim.api.nvim_win_set_cursor(dest_win, {
                      dest_pos.line + 1,
                      dest_pos.character,
                    })
                    for _, menu_to_close in ipairs(menus_to_close) do
                      menu_to_close:close()
                    end
                  end,
                }),
              },
            })
          )
        end
        -- Create a new menu for the symbol
        self.menu = menu.winbar_menu_t:new({
          cursor = self.data.lsp.idx and { self.data.lsp.idx, 0 } or nil,
          entries = entries,
        })
      end
      self.menu:toggle()
    end,
  }, opts or {}))
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
        convert_document_symbol(symbol, {
          data = {
            lsp = {
              idx = idx,
              symbols_list = lsp_symbols,
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
