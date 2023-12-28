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

return M
