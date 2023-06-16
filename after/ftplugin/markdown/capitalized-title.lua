local api = vim.api

local lowercase_words = {
  ['a'] = true,
  ['an'] = true,
  ['and'] = true,
  ['as'] = true,
  ['at'] = true,
  ['but'] = true,
  ['by'] = true,
  ['for'] = true,
  ['if'] = true,
  ['in'] = true,
  ['nor'] = true,
  ['of'] = true,
  ['off'] = true,
  ['on'] = true,
  ['or'] = true,
  ['per'] = true,
  ['so'] = true,
  ['the'] = true,
  ['than'] = true,
  ['to'] = true,
  ['up'] = true,
  ['via'] = true,
  ['vs'] = true,
  ['yet'] = true,
}

---Given current line, determine if it is a title line
---@param lines string[] buffer lines up to current line
---@return boolean
local function on_title_line(lines)
  local current_line = lines[#lines]
  return not require('utils.funcs').ft.markdown.in_code_block(lines)
    and current_line:match('^#+%s')
end

---Given current cursor position (column) and current line, determine if
---the cursor is on a word boundary
---@param line string current line
---@param col number current cursor position (column)
---@return boolean
local function on_word_boundary(line, col)
  local char_before = line:sub(col - 1, col - 1)
  if char_before:match('%w') or char_before == "'" then
    return false
  end
  return true
end

---Determine if a word is the first word on a line
---@param line string the line where the word is located
---@param col number current cursor position (column)
---@param word string word to check
---@return boolean
local function first_word(line, col, word)
  local text_before = line:sub(1, col - #word - 1)
  if text_before:match('%w') then
    return false
  end
  return true
end

---Given current cursor position (column) and current line, correct
---the word before the cursor if it should be in lower case
---@param line string current line
---@param col number current cursor position (column)
local function correct_word_before(line, col)
  local word_before = line:sub(1, col - 1):match('%w+$')
  if word_before == nil then
    return
  end

  if
    lowercase_words[word_before:lower()]
    and not first_word(line, col, word_before)
  then
    word_before = word_before:lower()
    line = line:sub(1, col - #word_before - 1) .. word_before .. line:sub(col)
    api.nvim_set_current_line(line)
  end
end

---Capitalize the first letter of words on title line
local function format_title(info)
  if not vim.bo[info.buf].filetype == 'markdown' then
    return
  end

  local cursor = api.nvim_win_get_cursor(0)
  local lines = api.nvim_buf_get_lines(info.buf, 0, cursor[1], false)
  if not on_title_line(lines) then
    return
  end

  local col = cursor[2]
  local current_line = lines[#lines]
  local char_current = current_line:sub(col, col)
  if on_word_boundary(current_line, col) and char_current:match('%a') then
    current_line = current_line:sub(1, col - 1)
      .. string.upper(current_line:sub(col, col))
      .. current_line:sub(col + 1)
    api.nvim_set_current_line(current_line)
  elseif char_current:match('%W') and char_current ~= '-' then
    correct_word_before(current_line, col)
  end
end

api.nvim_create_autocmd('TextChangedI', {
  group = api.nvim_create_augroup('MarkdownAutoFormatTitle', {}),
  callback = format_title,
})
