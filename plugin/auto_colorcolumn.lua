local api = vim.api
local g = vim.g

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
  return dec2hex(math.floor(rgb[1]))
      .. dec2hex(math.floor(rgb[2]))
      .. dec2hex(math.floor(rgb[3]))
end

---Blend two hex colors
---@param hex1 string the first color in hdex
---@param hex2 string the second color in hdex
---@param alpha number between 0~1, weight of the first color
---@return string hex_blended blended hex color
local function blend(hex1, hex2, alpha)
  local rgb1 = hex2rgb(hex1)
  local rgb2 = hex2rgb(hex2)

  local rgb_blended = {
    alpha * rgb1[1] + (1 - alpha) * rgb2[1],
    alpha * rgb1[2] + (1 - alpha) * rgb2[2],
    alpha * rgb1[3] + (1 - alpha) * rgb2[3],
  }

  local hex_blended = rgb2hex(rgb_blended)
  hex_blended = string.rep('0', 6 - #hex_blended) .. hex_blended
  return hex_blended
end

---Get background color in hex
---@param hlgroup string
---@param field string 'foreground' or 'background'
---@return string
local function get_hl(hlgroup, field)
  return dec2hex(api.nvim_get_hl_by_name(hlgroup, true)[field] or 0)
end

api.nvim_create_autocmd({ 'UIEnter', 'ColorScheme' }, {
  callback = function()
    g.colorcolumn_bg = get_hl('ColorColumn', 'background')
    api.nvim_set_hl(0, 'ColorColumn', {})
  end
})

api.nvim_create_autocmd({
  'ModeChanged', 'TextChangedI',
  'CursorMovedI', 'ColorScheme',
}, {
  callback = function ()
    if vim.o.cc == '' then
      return
    end

    local length = #vim.api.nvim_get_current_line()
    local cc = tonumber(vim.o.cc)
    local thresh = math.floor(cc * 0.75)
    -- Show colored column in insert mode only
    if vim.fn.mode():match('^i') then
      if length < cc then -- Show blended color when length < cc
        api.nvim_set_hl(0, 'ColorColumn', {
          bg = '#' .. blend(g.colorcolumn_bg,
                            get_hl('Normal', 'background'),
                            math.max(0, (length - thresh) / (cc - thresh)))
        })
      else  -- Show error color when length >= cc
        api.nvim_set_hl(0, 'ColorColumn', {
          bg = '#' .. blend(get_hl('Normal', 'background'),
                            get_hl('Error', 'foreground'), 0.6)
        })
      end
    else  -- Hide colored column in other modes
      api.nvim_set_hl(0, 'ColorColumn', {})
    end
  end
})