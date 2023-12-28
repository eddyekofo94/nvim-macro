local M = {}

---See `:h 'quickfixtextfunc'`
---@param info table
---@return string[]
function M.qftf(info)
  local qflist = info.quickfix == 1
      and vim.fn.getqflist({ id = info.id, items = 0 }).items
    or vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items

  if vim.tbl_isempty(qflist) then
    return {}
  end

  ---@param trans fun(item: table): string|number
  ---@param max_width integer?
  ---@return integer
  local function _get_width(trans, max_width)
    return math.min(
      max_width or math.huge,
      math.max(unpack(vim.tbl_map(function(item)
        return vim.fn.strdisplaywidth(tostring(trans(item)))
      end, qflist)))
    )
  end

  ---@param item table
  ---@return string
  local function _fname_trans(item)
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(item.bufnr), ':~:.')
  end

  ---@param item table
  ---@return string|integer
  local function _lnum_trans(item)
    if item.lnum == item.end_lnum or item.end_lnum == 0 then
      return item.lnum
    end
    return string.format('%s-%s', item.lnum, item.end_lnum)
  end

  ---@param item table
  ---@return string|integer
  local function _col_trans(item)
    if item.col == item.end_col then
      return item.col
    end
    return string.format('%s-%s', item.col, item.end_col)
  end

  local type_sign_map = {
    E = 'ERROR',
    W = 'WARN',
    I = 'INFO',
    N = 'HINT',
  }

  ---@param item table
  ---@return string
  local function _type_trans(item)
    -- Sometimes `item.type` will contain unprintable characters,
    -- e.g. items in the qflist of `:helpg vim`
    local type = (type_sign_map[item.type] or item.type):gsub('[^%g]', '')
    return type == '' and '' or ' ' .. type
  end

  ---@param item table
  ---@return string
  local function _nr_trans(item)
    return item.nr == 0 and '' or ' ' .. item.nr
  end

  local max_width = math.ceil(vim.go.columns / 2)
  local fname_width = _get_width(_fname_trans, max_width)
  local lnum_width = _get_width(_lnum_trans, max_width)
  local col_width = _get_width(_col_trans, max_width)
  local type_width = _get_width(_type_trans, max_width)
  local nr_width = _get_width(_nr_trans, max_width)

  local format_str = vim.g.modern_ui and '%s %s col %s%s%s %s'
    or '%s│%s col %s%s%s│ %s'
  return vim.tbl_map(function(item)
    if item.valid == 0 then
      return ''
    end

    local fname = tostring(_fname_trans(item))
    if item.lnum == 0 and item.col == 0 then
      return fname
    end

    local lnum = tostring(_lnum_trans(item))
    local col = tostring(_col_trans(item))
    local type = tostring(_type_trans(item))
    local nr = tostring(_nr_trans(item))
    return string.format(
      format_str,
      -- Do not use `string.format()` here because it only allows
      -- at most 99 characters for alignment and alignment is
      -- based on byte length instead of display length
      fname .. string.rep(' ', fname_width - vim.fn.strdisplaywidth(fname)),
      string.rep(' ', lnum_width - vim.fn.strdisplaywidth(lnum)) .. lnum,
      col .. string.rep(' ', col_width - vim.fn.strdisplaywidth(col)),
      type .. string.rep(' ', type_width - vim.fn.strdisplaywidth(type)),
      nr .. string.rep(' ', nr_width - vim.fn.strdisplaywidth(nr)),
      item.text
    )
  end, qflist)
end

-- Text object: folds
---Returns the key sequence to select around/inside a fold,
---supposed to be called in visual mode
---@param motion 'i'|'a'
---@return string
function M.textobj_fold(motion)
  local lnum = vim.fn.line('.') --[[@as integer]]
  local sel_start = vim.fn.line('v')
  local lev = vim.fn.foldlevel(lnum)
  local levp = vim.fn.foldlevel(lnum - 1)
  -- Multi-line selection with cursor on top of selection
  if sel_start > lnum then
    return (lev == 0 and 'zk' or lev > levp and levp > 0 and 'k' or '')
      .. vim.v.count1
      .. (motion == 'i' and ']zkV[zj' or ']zV[z')
  end
  return (lev == 0 and 'zj' or lev > levp and 'j' or '')
    .. vim.v.count1
    .. (motion == 'i' and '[zjV]zk' or '[zV]z')
end

---Go to the first line of current paragraph
---@return nil
function M.goto_paragraph_firstline()
  local chunk_size = 10
  local linenr = vim.fn.line('.')
  local count = vim.v.count1

  -- If current line is the first line of paragraph, move one line
  -- upwards first to goto the first line of previous paragraph
  if linenr >= 2 then
    local lines = vim.api.nvim_buf_get_lines(0, linenr - 2, linenr, false)
    if lines[1]:match('^$') and lines[2]:match('%S') then
      linenr = linenr - 1
    end
  end

  while linenr >= 1 do
    local chunk = vim.api.nvim_buf_get_lines(
      0,
      math.max(0, linenr - chunk_size - 1),
      linenr - 1,
      false
    )
    for i, line in ipairs(vim.iter(chunk):rev():totable()) do
      local current_linenr = linenr - i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr + 1))
          return
        end
      elseif current_linenr <= 1 then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd('1')
        return
      end
    end
    linenr = linenr - chunk_size
  end
end

---Go to the last line of current paragraph
---@return nil
function M.goto_paragraph_lastline()
  local chunk_size = 10
  local linenr = vim.fn.line('.')
  local buf_line_count = vim.api.nvim_buf_line_count(0)
  local count = vim.v.count1

  -- If current line is the last line of paragraph, move one line
  -- downwards first to goto the last line of next paragraph
  if buf_line_count - linenr >= 1 then
    local lines = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr + 1, false)
    if lines[1]:match('%S') and lines[2]:match('^$') then
      linenr = linenr + 1
    end
  end

  while linenr <= buf_line_count do
    local chunk =
      vim.api.nvim_buf_get_lines(0, linenr, linenr + chunk_size, false)
    for i, line in ipairs(chunk) do
      local current_linenr = linenr + i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr - 1))
          return
        end
      elseif current_linenr >= buf_line_count then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd(tostring(buf_line_count))
        return
      end
    end
    linenr = linenr + chunk_size
  end
end

---Close floating windows with 'q'
--- 1. If current window is a floating window, close it and return
--- 2. Else, close all floating windows that can be focused
--- 3. Fallback to normal mode 'q' if no floating window can be focused
---@return nil
function M.q()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- Close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      -- Close floating windows that can be focused
      if config.relative ~= '' and config.focusable then
        vim.api.nvim_win_close(win, false) -- do not force
        count = count + 1
      end
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('q', true, true, true),
      'n',
      false
    )
  end
end

return M
