local todec = {
  ['0'] = 0,
  ['1'] = 1,
  ['2'] = 2,
  ['3'] = 3,
  ['4'] = 4,
  ['5'] = 5,
  ['6'] = 6,
  ['7'] = 7,
  ['8'] = 8,
  ['9'] = 9,
  ['A'] = 10,
  ['B'] = 11,
  ['C'] = 12,
  ['D'] = 13,
  ['E'] = 14,
  ['F'] = 15,
}

local tohex = {
  [0]  = '0',
  [1]  = '1',
  [2]  = '2',
  [3]  = '3',
  [4]  = '4',
  [5]  = '5',
  [6]  = '6',
  [7]  = '7',
  [8]  = '8',
  [9]  = '9',
  [10] = 'A',
  [11] = 'B',
  [12] = 'C',
  [13] = 'D',
  [14] = 'E',
  [15] = 'F',
}

local store = {
  previous_cc = '', ---@type string
  colorcol_bg = '', ---@type string
}

---Convert an integer from hexadecimal to decimal
---@param hex string
---@return integer dec
local function hex2dec(hex)
  local digit = 1
  local dec = 0

  while digit <= #hex do
    dec = dec + todec[string.sub(hex, digit, digit)] * 16^(#hex - digit)
    digit = digit + 1
  end

  return dec
end

---Convert an integer from decimal to hexadecimal
---@param int integer
---@return string hex
local function dec2hex(int)
  local hex = ''

  while int > 0 do
    hex = tohex[int % 16] .. hex
    int = math.floor(int / 16)
  end

  return hex
end

---Convert a hex color to rgb color
---@param hex string hex code of the color
---@return integer[] rgb
local function hex2rgb(hex)
  local red = string.sub(hex, 1, 2)
  local green = string.sub(hex, 3, 4)
  local blue = string.sub(hex, 5, 6)

  return {
    hex2dec(red),
    hex2dec(green),
    hex2dec(blue),
  }
end

---Convert an rgb color to hex color
---@param rgb integer[]
---@return string
local function rgb2hex(rgb)
  local hex = {
    dec2hex(math.floor(rgb[1])),
    dec2hex(math.floor(rgb[2])),
    dec2hex(math.floor(rgb[3])),
  }
  hex = {
    string.rep('0', 2 - #hex[1]) .. hex[1],
    string.rep('0', 2 - #hex[2]) .. hex[2],
    string.rep('0', 2 - #hex[3]) .. hex[3],
  }
  return table.concat(hex, '')
end

---Blend two hex colors
---@param hex1 string the first color in hdex
---@param hex2 string the second color in hdex
---@param alpha number between 0~1, weight of the first color
---@return string hex_blended blended hex color
local function blend(hex1, hex2, alpha)
  local rgb1 = hex2rgb(hex1:gsub('#', '', 1))
  local rgb2 = hex2rgb(hex2:gsub('#', '', 1))

  local rgb_blended = {
    alpha * rgb1[1] + (1 - alpha) * rgb2[1],
    alpha * rgb1[2] + (1 - alpha) * rgb2[2],
    alpha * rgb1[3] + (1 - alpha) * rgb2[3],
  }

  return '#' .. rgb2hex(rgb_blended)
end

---Get background color in hex
---@param hlgroup_name string
---@param field string 'foreground' or 'background'
---@param fallback string|nil fallback color in hex, default to '#000000'
---@return string hex color
local function get_hl(hlgroup_name, field, fallback)
  fallback = fallback or '#000000'
  local has_hlgroup, hlgroup =
    pcall(vim.api.nvim_get_hl_by_name, hlgroup_name, true)
  if has_hlgroup and hlgroup[field] then
    return dec2hex(hlgroup[field])
  end
  return fallback
end

---Resolve the colorcolumn value
---@param cc string|nil
---@return integer|nil cc_number smallest integer >= 0 or nil
local function resolve_cc(cc)
  if not cc or cc == '' then
    return nil
  end
  local cc_tbl = vim.split(cc, ',')
  local cc_min = nil
  for _, cc_str in ipairs(cc_tbl) do
    local cc_number = tonumber(cc_str)
    if vim.startswith(cc_str, '+') or vim.startswith(cc_str, '-') then
      cc_number = vim.bo.tw > 0 and vim.bo.tw + cc_number or nil
    end
    if cc_number and cc_number > 0 and (not cc_min or cc_number < cc_min) then
      cc_min = cc_number
    end
  end
  return cc_min
end

---Set a window-local option safely without changing the window view
---@param win integer window handle, 0 for current window
---@param name string option name
---@param value any option value
local function win_safe_set_option(win, name, value)
  local winview = vim.fn.winsaveview()
  vim.wo[win][name] = value
  vim.fn.winrestview(winview)
end

---Fallback to the first non-empty string
---@vararg string
---@return string|nil
local function str_fallback(...)
  local args = { ... }
  for _, arg in pairs(args) do
    if type(arg) == 'string' and arg ~= '' then
      return arg
    end
  end
  return nil
end

---Set to be relative to textwidth if textwidth is set
local function cc_set_relative()
  if vim.bo.textwidth > 0 then
    vim.w.cc = '+1'
  else
    vim.w.cc = str_fallback(vim.b.cc, vim.g.cc)
  end
end

---Redraw colorcolumn
local function cc_redraw()
  local cc = resolve_cc(vim.w.cc)
  local mode = vim.fn.mode()
  if not cc
    or not vim.startswith(mode, 'i')
      and not vim.startswith(mode, 'R')
  then
    win_safe_set_option(0, 'cc', '')
    return
  end

  local length = vim.fn.strdisplaywidth(vim.api.nvim_get_current_line())
  local thresh = math.floor(0.75 * cc)
  if length < thresh then
    win_safe_set_option(0, 'cc', '')
    return
  end

  win_safe_set_option(0, 'cc', vim.w.cc)

  -- Show blended color when len < cc
  local normal_bg = get_hl('Normal', 'background')
  if length < cc then
    vim.api.nvim_set_hl(0, 'ColorColumn', {
      bg = blend(
        store.colorcol_bg,
        normal_bg,
        (length - thresh) / (cc - thresh)
      ),
    })
  else -- Show error color when length >= cc
    local warning_color = get_hl('Error', 'foreground', '#FF0000')
    vim.api.nvim_set_hl(0, 'ColorColumn', {
      bg = blend(warning_color, normal_bg, 0.4),
    })
  end
end

---Hide the colorcolumn
local function init()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    vim.w[win].cc = vim.wo[win].cc
  end
  vim.g.cc = vim.go.cc
  for _, win in ipairs(wins) do
    vim.wo[win].cc = ''
  end
  vim.go.cc = ''
  store.colorcol_bg = get_hl('ColorColumn', 'background')
  vim.api.nvim_create_augroup('AutoColorColumn', { clear = true })
end

-- colorcolumn is a window-local option, with some special rules:
-- 1. When a window is created, it inherits the value of the previous window or
--    the global option
-- 2. When a different buffer is displayed in current window, window-local cc
--    settings changes to the value when the buffer is displayed in the first
--    time, if there's no such value, it uses value of the global option
-- 3. Once the window-local cc is set, it's not changed by the global option
--    or inheritance, it will only change when a different buffer is displayed
--    or the option is set explicitly (via set or setlocal)

---Make autocmds to track colorcolumn settings
local function autocmd_track_cc()
  -- Save previous window cc settings
  vim.api.nvim_create_autocmd({ 'WinLeave' }, {
    group = 'AutoColorColumn',
    callback = function()
      store.previous_cc = vim.w.cc
      win_safe_set_option(0, 'cc', '')
    end,
  })

  -- Broadcast previous window or global cc settings to new windows
  vim.api.nvim_create_autocmd({ 'WinNew' }, {
    group = 'AutoColorColumn',
    callback = function()
      vim.w.cc = str_fallback(store.previous_cc, vim.g.cc)
    end,
  })

  -- Save cc settings for each window
  vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    group = 'AutoColorColumn',
    callback = function()
      vim.w.cc = str_fallback(vim.w.cc, vim.wo.cc)
    end,
  })

  -- On entering a buffer, check and set vim.b.cc and vim.w.cc in the
  -- following order:
  -- 1. If vim.wo.cc is non empty, then it is set from a modeline, use it.
  --    Notice that this is after the 'FileType' event, which applies ftplugin
  --    settings
  -- 2. If vim.b.cc if non empty, it is set previously by broadcasting or an
  --    ftplugin, use it
  -- 3. Else use vim.g.cc
  -- We want to unset vim.wo.cc on leaving a buffer, so that vim.wo.cc reflects
  -- changes from modelines
  vim.api.nvim_create_autocmd({ 'BufLeave' }, {
    group = 'AutoColorColumn',
    callback = function()
      win_safe_set_option(0, 'cc', '')
    end,
  })
  vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    group = 'AutoColorColumn',
    callback = function()
      vim.b.cc = str_fallback(vim.wo.cc, vim.b.cc, vim.g.cc)
      vim.w.cc = str_fallback(vim.wo.cc, vim.b.cc, vim.g.cc)
      local mode = vim.fn.mode()
      if not vim.startswith(mode, 'i') or not vim.startswith(mode, 'R') then
        win_safe_set_option(0, 'cc', '')
      end
    end,
  })

  -- Update cc settings on option change
  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = 'colorcolumn',
    group = 'AutoColorColumn',
    callback = function()
      if vim.v.option_type == 'global' then
        vim.g.cc = vim.go.cc
        vim.w.cc = vim.go.cc
        vim.b.cc = vim.go.cc
      elseif vim.v.option_type == 'local' then
        vim.w.cc = vim.wo.cc
        vim.b.cc = vim.wo.cc
      end
      vim.go.cc = ''
      win_safe_set_option(0, 'cc', '')
    end,
  })

  -- Handle cc settings from ftplugins
  -- Detect cc changes in a quite hacky way, because OptionSet autocmd is not
  -- triggered when cc is set in a ftplugin
  -- Quirk: these two commands are not the same in a ftplugin:
  --     setlocal cc=80 " vimscript
  --     vim.wo.cc = 80 -- lua
  -- The former (vimscript) will set the 'buffer-local' cc, i.e. it will set cc
  -- for current window BUT will be reset for a different buffer displayed in
  -- the same window.
  -- The latter (lua) will set the 'window-local' cc, i.e. it will set cc for
  -- current window and will NOT be reset for a different buffer displayed in
  -- the same window.
  -- Currently there is no way to tell which one is used in a ftplugin, since I
  -- prefer the vimscript way, I simulate its behavior here when a change is
  -- detected for cc in current window.
  vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
    group = 'AutoColorColumn',
    callback = function()
      vim.b._cc = vim.wo.cc
      vim.g._cc = vim.go.cc
    end,
  })
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = 'AutoColorColumn',
    callback = function()
      -- If cc changes between BufReadPre and FileType, it is an ftplugin
      -- that sets cc, so we accept it as a 'buffer-local' (phony) cc setting
      -- Notice that we will do nothing if vim.b._cc is nil, which means the
      -- buffer is not the same buffer that triggers BufReadPre
      if vim.b._cc and vim.wo.cc ~= vim.b._cc then
        vim.b.cc = vim.wo.cc
        if vim.go.cc ~= vim.g._cc then
          vim.g.cc = vim.go.cc
        end
      end
    end,
  })
end

---Make autocmds to set colorcolumn relative to textwidth
local function autocmd_follow_tw()
  -- Set cc to be relative to textwidth if textwidth is set
  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = 'textwidth',
    group = 'AutoColorColumn',
    callback = cc_set_relative,
  })
  vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    group = 'AutoColorColumn',
    callback = cc_set_relative,
  })
end

---Make autocmds to display colorcolumn
local function autocmd_display_cc()
  -- Save Colorcolum background color
  vim.api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
    group = 'AutoColorColumn',
    callback = function()
      store.colorcol_bg = get_hl('ColorColumn', 'background')
    end,
  })

  -- Show colored column
  vim.api.nvim_create_autocmd(
    {
      'ModeChanged',
      'TextChangedI',
      'CursorMovedI',
      'ColorScheme',
    },
    {
      group = 'AutoColorColumn',
      callback = cc_redraw
    }
  )
  vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = { 'colorcolumn', 'textwidth' },
    group = 'AutoColorColumn',
    callback = cc_redraw,
  })
end

init()
autocmd_follow_tw()
autocmd_track_cc()
autocmd_display_cc()
