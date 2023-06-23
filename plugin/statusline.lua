_G.statusline = {}
local utils = require('utils')

-- stylua: ignore start
local modes = {
  ['n']    = 'NO',
  ['no']   = 'OP',
  ['nov']  = 'OC',
  ['noV']  = 'OL',
  ['no'] = 'OB',
  ['']   = 'VB',
  ['niI']  = 'IN',
  ['niR']  = 'RE',
  ['niV']  = 'RV',
  ['nt']   = 'NT',
  ['ntT']  = 'TM',
  ['v']    = 'VI',
  ['vs']   = 'VI',
  ['V']    = 'VL',
  ['Vs']   = 'VL',
  ['s']  = 'VB',
  ['s']    = 'SE',
  ['S']    = 'SL',
  ['']   = 'SB',
  ['i']    = 'IN',
  ['ic']   = 'IC',
  ['ix']   = 'IX',
  ['R']    = 'RE',
  ['Rc']   = 'RC',
  ['Rx']   = 'RX',
  ['Rv']   = 'RV',
  ['Rvc']  = 'RC',
  ['Rvx']  = 'RX',
  ['c']    = 'CO',
  ['cv']   = 'CV',
  ['r']    = 'PR',
  ['rm']   = 'PM',
  ['r?']   = 'P?',
  ['!']    = 'SH',
  ['t']    = 'TE',
}
-- stylua: ignore end

---Get string representation of the current mode
function statusline.mode()
  local hl = vim.bo.mod and 'StatusLineHeaderModified' or 'StatusLineHeader'
  return utils.funcs.stl.hl(' ' .. modes[vim.fn.mode()] .. ' ', hl)
end

function statusline.info()
  if vim.bo.bt ~= '' then
    return ''
  end
  local info = {}
  if vim.bo.ft ~= '' then
    table.insert(info, (vim.bo.ft:gsub('^%l', string.upper)))
  end
  local br = utils.funcs.git.branch()
  if br ~= '' then
    table.insert(info, utils.funcs.stl.hl('#' .. br, 'StatusLineGitBranch'))
  end
  return vim.tbl_isempty(info) and ''
    or string.format('(%s)', table.concat(info, ', '))
end

---@type table<string, string>
local components = {
  padding = '%#None# %*',
  mode = '%{%v:lua.statusline.mode()%}',
  filename = ' %t ',
  info = '%{%v:lua.statusline.info()%}',
  align = '%=',
  position = '%l:%c ',
}

local groupid = vim.api.nvim_create_augroup('StatusLine', {})
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter', 'CursorMoved' }, {
  group = groupid,
  callback = function()
    vim.wo.statusline = table.concat({
      components.padding,
      components.mode,
      components.filename,
      components.info,
      components.align,
      components.position,
      components.padding,
    })
  end,
})
vim.api.nvim_create_autocmd('WinLeave', {
  group = groupid,
  callback = function()
    vim.wo.statusline = table.concat({
      components.padding,
      components.filename,
      components.align,
      components.padding,
    })
  end,
})
