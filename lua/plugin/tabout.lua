local api = vim.api
local fmt = string.format

---@class fallbak_tbl_t each key shares a default / fallback pattern table
---that can be used for pattern matching if corresponding key is not present
---or non patterns stored in the key are matched
---@field __content table closing patterns for each filetype
local fallbak_tbl_t = {}

function fallbak_tbl_t:__index(k)
  return fallbak_tbl_t[k] or self:concat(k, '')
end

---Concatenate two pattern tables
---@param k1 string filetype (key) of the first table
---@param k2 string filetype (key) of the second table
---@return table concatenated table
function fallbak_tbl_t:concat(k1, k2)
  if k1 == k2 then
    return rawget(self.__content, k1) or {}
  end

  local tbl1 = rawget(self.__content, k1)
  local tbl2 = rawget(self.__content, k2)
  if tbl1 and tbl2 then
    for _, v in ipairs(tbl2) do
      table.insert(tbl1, v)
    end
    return tbl1
  elseif tbl1 then
    return tbl1
  elseif tbl2 then
    return tbl2
  end

  return {}
end

---Create a new shared table
---@param init_tbl table|nil initial table
---@return fallbak_tbl_t
function fallbak_tbl_t:new(init_tbl)
  local shared_tbl = {
    __content = init_tbl or {},
  }
  return setmetatable(shared_tbl, self)
end

local patterns = fallbak_tbl_t:new({
  ['']         = { '%)', '%]', '}', '"', "'", '`', ',', ';', '%.' },
  ['c']        = { '%*/' },
  ['cpp']      = { '%*/' },
  ['lua']      = { '%]%]' },
  ['python']   = { '"""', "'''" },
  ['markdown'] = {
    '\\right\\rfloor',
    '\\right\\rceil',
    '\\right\\vert',
    '\\right\\Vert',
    '\\right%)',
    '\\right%]',
    '\\right}',
    '\\right>',
    '\\%]',
    '\\%)',
    '\\}',
    '-->',
    '%*%*%*',
    '%*%*',
    '%*',
    '%$',
    '|',
  },
  ['tex']      = {
    '\\right\\rfloor',
    '\\right\\rceil',
    '\\right\\vert',
    '\\right\\Vert',
    '\\right%)',
    '\\right%]',
    '\\right}',
    '\\right>',
    '\\%]',
    '\\%)',
    '\\}',
    '%$',
  },
})

local opening_pattern_lookup_tbl = {
  ["'"]               = "'",
  ['"']               = '"',
  [',']               = '.',
  [';']               = '.',
  ['`']               = '`',
  ['|']               = '|',
  ['}']               = '{',
  ['%.']              = '.',
  ['%$']              = '%$',
  ['%)']              = '%(',
  ['%]']              = '%[',
  ['%*']              = '%*',
  ['%*%*']            = '%*%*',
  ['%*%*%*']          = '%*%*%*',
  ['"""']             = '"""',
  ["'''"]             = "'''",
  ['%*/']             = '/%*',
  ['\\}']             = '\\{',
  ['-->']             = '<!--',
  ['\\%)']            = '\\%(',
  ['\\%]']            = '\\%[',
  ['%]%]']            = '--%[%[',
  ['\\right}']        = '\\left{',
  ['\\right>']        = '\\left<',
  ['\\right%)']       = '\\left%(',
  ['\\right%]']       = '\\left%[',
  ['\\right\\vert']   = '\\left\\vert',
  ['\\right\\Vert']   = '\\left\\lVert',
  ['\\right\\rceil']  = '\\left\\lceil',
  ['\\right\\rfloor'] = '\\left\\lfloor',
}

---Get the index where Shift-Tab should jump to
---1. If there is only whitespace characters or no character in between
---   the opening and closing pattern, jump to the end of the whitespace
---   characters (i.e. right before the closing pattern)
---
---       1.1. Special case: if there is exactly two whitespace characters,
---            jump to the middle of the two whitespace characters
---
---2. If there is contents (non-whitespace characters) in between the
---   opening and closing pattern, jump to the end of the contents
---@param leading any leading texts on current line
---@param closing_pattern any closing pattern
---@param cursor number[] cursor position
---@return number[] cursor position after jump
local function jumpin_idx(leading, closing_pattern, cursor)
  local opening_pattern = opening_pattern_lookup_tbl[closing_pattern]

  -- Case 1
  local _, _, content_str, closing_pattern_str
    = leading:find(fmt('%s(%s)(%s)$', opening_pattern, '%s*', closing_pattern))
  if content_str == nil or closing_pattern_str == nil then
    _, _, content_str, closing_pattern_str
      = leading:find(fmt('^(%s)(%s)$', '%s*', closing_pattern))
  end

  if content_str and closing_pattern_str then
    -- Case 1.1
    if #content_str == 2 then
      return { cursor[1], cursor[2] - #closing_pattern_str - 1 }
    else
      return { cursor[1], cursor[2] - #closing_pattern_str }
    end
  end

  -- Case 2
  _, _, _, closing_pattern_str
    = leading:find(fmt('%s%s(%s)$',
      opening_pattern .. '%s*', '.*%S', '%s*' .. closing_pattern .. '%s*'))

  if content_str == nil or closing_pattern_str == nil then
    _, _, closing_pattern_str
      = leading:find(fmt('%s(%s)$', '%S', '%s*' .. closing_pattern .. '%s*'))
  end

  return { cursor[1], cursor[2] - #closing_pattern_str }
end

local get_jump_pos = {
  ---Getting the jump position for Tab
  ---@return number[]|boolean cursor position after jump; false if no jump
  ['<Tab>'] = function()
    local cursor = api.nvim_win_get_cursor(0)
    local current_line = api.nvim_get_current_line()
    local trailing = current_line:sub(cursor[2] + 1, -1)
    local leading = current_line:sub(1, cursor[2])

    -- Do not jump if the cursor is at the beginning/end of the current line
    if leading:match('^%s*$') or trailing == '' then
      return false
    end

    for _, pattern in ipairs(patterns[vim.bo.ft or '']) do
      local _, jump_pos = trailing:find('^%s*' .. pattern)
      if jump_pos then
        return { cursor[1], cursor[2] + jump_pos }
      end
    end

    return false
  end,

  ---Getting the jump position for Shift-Tab
  ---@return number[]|boolean cursor position after jump; false if no jump
  ['<S-Tab>'] = function()
    local cursor = api.nvim_win_get_cursor(0)
    local current_line = api.nvim_get_current_line()
    local leading = current_line:sub(1, cursor[2])

    for _, pattern in ipairs(patterns[vim.bo.ft or '']) do
      local _, closing_pattern_end = leading:find(pattern .. '%s*$')
      if closing_pattern_end then
        return jumpin_idx(leading:sub(1, closing_pattern_end), pattern, cursor)
      end
    end

    return false
  end
}

---Get the position to jump for Tab or Shift-Tab, perform the jump if
---there is a position to jump to, otherwise fallback (feedkeys)
---@param key string key to be pressed
local function do_key(key)
  local pos = get_jump_pos[key]()
  if pos then
    api.nvim_win_set_cursor(0, pos)
  else
    local termcode = api.nvim_replace_termcodes(key, true, true, true)
    api.nvim_feedkeys(termcode, 'in', false)
  end
end

return {
  do_key = do_key,
  get_jump_pos = function(key)
    return get_jump_pos[key]()
  end,
}
