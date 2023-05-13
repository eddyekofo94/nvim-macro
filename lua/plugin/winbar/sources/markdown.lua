local initialized = false
local heading_icons = { '󰉫 ', '󰉬 ', '󰉭 ', '󰉮 ', '󰉯 ', '󰉰 ' }
local groupid = vim.api.nvim_create_augroup('WinBarMarkdown', {})

---@class markdown_heading_symbol_t
---@field name string
---@field level number
---@field lnum number

---@class markdown_heading_symbols_parsed_t
---@field end number
---@field symbols markdown_heading_symbol_t[]

---@type table<number, markdown_heading_symbols_parsed_t>
local markdown_heading_buf_symbols = {}

---Parse markdown file and update markdown heading symbols
---Side effect: change markdown_heading_buf_symbols
---@param buf number buffer handler
---@param symbols_parsed markdown_heading_symbols_parsed_t (reference to) parsed symbols
---@param lnum_end? number update symbols backward from this line
---@return nil
local function parse_buf(buf, symbols_parsed, lnum_end)
  symbols_parsed.symbols = {}
  symbols_parsed['end'] = lnum_end
  lnum_end = lnum_end or vim.api.nvim_buf_line_count(buf)
  local inside_code_block = false
  local lines = vim.api.nvim_buf_get_lines(buf, 0, lnum_end, true)
  for lnum, line in ipairs(lines) do
    if line:match('^```') then
      inside_code_block = not inside_code_block
    end
    if not inside_code_block then
      local _, _, heading_notation, heading_str = line:find('^(#+)%s+(.*)')
      local level = heading_notation and #heading_notation or nil
      if level and level >= 1 and level <= 6 then
        table.insert(symbols_parsed.symbols, {
          name = heading_str,
          level = #heading_notation,
          lnum = lnum,
        })
      end
    end
  end
end

---Convert markdown heading symbols into a list of winbar symbols according to
---cursor position
---@param symbols markdown_heading_symbol_t[] markdown heading symbols
---@param cursor integer[] cursor position
---@return winbar_symbol_t[]
local function convert(symbols, cursor)
  local result = {}
  local current_level = 7
  for symbol in vim.iter(symbols):rev() do
    if symbol.lnum <= cursor[1] and symbol.level < current_level then
      current_level = symbol.level
      table.insert(result, 1, {
        icon = heading_icons[symbol.level],
        name = symbol.name,
        icon_hl = 'markdownH' .. symbol.level,
      })
      if current_level == 1 then
        break
      end
    end
  end
  return result
end

---Attach markdown heading parser to buffer
---@param buf number buffer handler
---@return nil
local function attach(buf)
  if vim.b[buf].winbar_markdown_heading_parser_attached then
    return
  end
  local function _update()
    markdown_heading_buf_symbols[buf] = markdown_heading_buf_symbols[buf] or {}
    parse_buf(buf, markdown_heading_buf_symbols[buf])
  end
  vim.b[buf].winbar_markdown_heading_parser_attached = vim.api.nvim_create_autocmd(
    { 'TextChanged', 'TextChangedI' },
    {
      desc = 'Update markdown heading symbols on buffer change.',
      group = groupid,
      buffer = buf,
      callback = _update,
    }
  )
  _update()
end

---Detach markdown heading parser from buffer
---@param buf number buffer handler
---@return nil
local function detach(buf)
  if vim.b[buf].winbar_markdown_heading_parser_attached then
    vim.api.nvim_del_autocmd(
      vim.b[buf].winbar_markdown_heading_parser_attached
    )
    vim.b[buf].winbar_markdown_heading_parser_attached = nil
    markdown_heading_buf_symbols[buf] = nil
  end
end

---Initialize markdown heading source
---@return nil
local function init()
  if initialized then
    return
  end
  initialized = true
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == 'markdown' then
      attach(buf)
    end
  end
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    desc = 'Attach markdown heading parser to markdown buffers.',
    group = groupid,
    callback = function(info)
      if vim.bo[info.buf].filetype == 'markdown' then
        attach(info.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    desc = 'Attach markdown heading parser to markdown buffers.',
    group = groupid,
    pattern = 'markdown',
    callback = function(info)
      attach(info.buf)
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufDelete', 'BufUnload', 'BufWipeOut' }, {
    desc = 'Detach markdown heading parser from buffer on buffer delete/unload/wipeout.',
    group = groupid,
    callback = function(info)
      if vim.bo[info.buf].filetype == 'markdown' then
        detach(info.buf)
      end
    end,
  })
  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    desc = 'Attach / Detach markdown heading parser from buffer on filetype change.',
    group = groupid,
    pattern = 'filetype',
    callback = function(info)
      if vim.v.option_new == 'markdown' then
        attach(info.buf)
      else
        detach(info.buf)
      end
    end,
  })
end

---Get winbar symbols from buffer according to cursor position
---@param buf number buffer handler
---@param cursor number[] cursor position
---@return winbar_symbol_t[] symbols winbar symbols
local function get_symbols(buf, cursor)
  if vim.bo[buf].filetype ~= 'markdown' then
    return {}
  end
  if not initialized then
    init()
  end
  local buf_symbols = markdown_heading_buf_symbols[buf] or {}
  if -- Update heading symbols if cursor is out of range
    not buf_symbols['end'] or buf_symbols['end'] < cursor[1]
  then
    parse_buf(buf, buf_symbols, cursor[1])
  end
  return convert(buf_symbols.symbols or {}, cursor)
end

return {
  get_symbols = get_symbols,
}
