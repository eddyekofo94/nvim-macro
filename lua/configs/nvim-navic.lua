local navic = require('nvim-navic')
local displen = vim.fn.strdisplaywidth
navic.setup({
  icons = vim.tbl_map(function(icon)
    return vim.trim(icon)
  end, require('utils.static').icons),
  highlight = true,
  separator = ' ► ',
  safe_output = true
})

local function hl(str, hlgroup)
  if not hlgroup or hlgroup:match('^%s*$') then
    return str
  end
  return string.format('%%#%s#%s%%*', hlgroup, str or '')
end

local function concat(tbl, padding, tbl_hl, padding_hl)
  if vim.fn.empty(tbl) == 1 then return '' end
  if not padding then padding = ' ' end
  if not tbl_hl then tbl_hl = {} end
  if not tbl_hl then tbl_hl = {} end
  local result = nil
  for i, str in ipairs(tbl) do
    -- Do not concat if str is empty or
    -- contains only white spaces
    if not str:match('^%s*$') then
      result = result and result .. hl(padding, padding_hl) .. vim.trim(hl(str, tbl_hl[i]))
          or vim.trim(hl(str, tbl_hl[i]))
    end
  end
  return vim.trim(result or '')
end

local function get_dir_list()
  if vim.fn.bufname('%') == '' then
    return {}
  end

  local sep = vim.loop.os_uname().sysname == 'Windows' and '\\' or '/'
  local dir_list = vim.split(vim.fn.expand('%:~:.:h'), sep)
  if #dir_list == 0 or #dir_list == 1 and dir_list[1] == '.' then
    return {}
  end

  return vim.tbl_map(function(dir_name)
    return { name = dir_name }
  end, dir_list)
end

local function get_file()
  if vim.fn.bufname('%') == '' then
    return {}
  end

  local fname = vim.fn.expand('%:t')
  local icon = vim.bo.bt == ''
      and require('nvim-web-devicons').get_icon(
        fname,
        vim.fn.fnamemodify(fname, ':e'),
        { default = true }
      )
    or ''
  return {
    icon = icon,
    name = fname,
  }
end

local function get_node_list()
  return vim.tbl_map(function(node)
    return {
      icon = node.icon,
      name = node.name,
      type = node.type,
    }
  end, navic.get_data() or {})
end

local function truncate_list(list, len_overshoot, truncate_method)
  local mid_left = math.ceil(#list / 2)
  local mid_right = #list - math.ceil(#list / 2) + 1
  local len_truncated = 0
  local truncated_str = ''
  while mid_left > 0 and mid_right <= #list do
    truncated_str = truncate_method(list[mid_left])
    len_truncated = len_truncated + (#list[mid_left] - #truncated_str)
    list[mid_left] = truncated_str
    mid_left = mid_left - 1
    if len_truncated >= len_overshoot then
      return list, 0
    end
    truncated_str = truncate_method(list[mid_right])
    len_truncated = len_truncated + (#list[mid_right] - #truncated_str)
    list[mid_right] = truncated_str
    mid_right = mid_right + 1
    if len_truncated >= len_overshoot then
      return list, 0
    end
  end
  return list, len_overshoot - len_truncated
end

local function eval_len(dir_list, file, node_list)

  if not dir_list then dir_list = {} end
  if not file then file = {} end
  if not node_list then node_list = {} end

  local dir_str = concat(vim.tbl_map(function(dir)
    return concat({ dir.icon or '', dir.name or '' })
  end, dir_list), ' ► ')

  local file_str = concat({
    file.icon or '',
    file.name or '',
  })

  local node_str = concat(vim.tbl_map(function(node)
    return concat({
      node.icon or '',
      node.name or ''
    })
  end, node_list), ' ► ')

  local winbar_str = concat({
    dir_str,
    file_str,
    node_str,
  }, ' ► ')
  if not winbar_str:match('^%s*$') then
    winbar_str = ' ' .. winbar_str .. ' '
  end

  return displen(winbar_str)
end

local function truncate(dir_list, file, node_list)
  local width = vim.fn.winwidth(0)
  local total_len = eval_len(dir_list, file, node_list)
  local len_overshoot = total_len - width


  if len_overshoot <= 0 then
    return dir_list, file, node_list
  end

  local dir_list_nameonly = vim.tbl_map(function(dir)
    return dir.name
  end, dir_list)
  dir_list_nameonly, len_overshoot =
  truncate_list(dir_list_nameonly, len_overshoot, function(str)
    if displen(str) > 2 then
      return str:sub(1, 1) .. '…'
    end
    return str
  end)
  for i, dir_name in ipairs(dir_list_nameonly) do
    dir_list[i].name = dir_name
  end

  if len_overshoot <= 0 then
    return dir_list, file, node_list
  end

  local node_list_nameonly = vim.tbl_map(function(node)
    return node.name
  end, node_list)
  node_list_nameonly, len_overshoot =
  truncate_list(node_list_nameonly, len_overshoot, function(str)
    if displen(str) > 2 then
      return str:sub(1, 1) .. '…'
    end
    return str
  end)
  for i, node_name in ipairs(node_list_nameonly) do
    node_list[i].name = node_name
  end

  if len_overshoot <= 0 then
    return dir_list, file, node_list
  end

  node_list = {}
  len_overshoot = eval_len(dir_list, file, node_list) - width

  if len_overshoot <= 0 then
    return dir_list, file, node_list
  end

  dir_list = {}
  len_overshoot = eval_len(dir_list, file, node_list) - width

  if len_overshoot <= 0 then
    return dir_list, file, node_list
  end

  return dir_list, file, node_list
end

function _G.get_winbar()
  local file = get_file()
  local dir_list = get_dir_list()
  local node_list = get_node_list()
  dir_list, file, node_list = truncate(dir_list, file, node_list)

  -- apply highlights to directory list and
  -- concat with highlighted separators
  local dir_str = concat(vim.tbl_map(function(dir)
    return concat({
      dir.icon or '',
      dir.name or '',
    }, ' ', {
      'Directory',
      'NavicPath',
    })
  end, dir_list), ' ► ', nil, 'Tea')

  -- apply highlights to file name
  local _, iconcolor = require('nvim-web-devicons').get_icon(file,
    vim.fn.fnamemodify(file.name, ':e'), { default = true })
  local file_str = concat({
    file.icon or '',
    file.name or ''
  }, ' ', {
    iconcolor,
    'NavicPath'
  })

  local node_str = concat(vim.tbl_map(function(node)
    return concat({
      node.icon or '',
      node.name or ''
    }, ' ', {
      'NavicIcons' .. (node.type or ''),
      'NavicText'
    })
  end, node_list), ' ► ', nil, 'Orange')

  -- concat three parts with highlighted separators and paddings
  local winbar_str = concat({
    dir_str,
    file_str,
  }, ' ► ', nil, 'Tea')
  winbar_str = concat({
    winbar_str,
    node_str,
  }, ' ► ', nil, 'Orange')
  if not winbar_str:match('^%s*$') then
    winbar_str = ' ' .. winbar_str .. ' '
  end

  return winbar_str
end

vim.opt.winbar = "%{%!&diff?v:lua.get_winbar():''%}"
vim.api.nvim_create_autocmd({ 'LspAttach' }, {
  group = vim.api.nvim_create_augroup('Navic', {}),
  callback = function(tbl)
    local client = vim.lsp.get_client_by_id(tbl.data.client_id)
    if client and client.supports_method('textDocument/documentSymbol') then
      navic.attach(client, tbl.buf)
    end
  end,
})
