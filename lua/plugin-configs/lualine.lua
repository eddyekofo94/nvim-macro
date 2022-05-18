local lualine = require('lualine')

local location = function ()
  local cursor_loc = vim.api.nvim_win_get_cursor(0)
  return cursor_loc[1] .. ',' .. cursor_loc[2] + 1
end

local clock = function ()
  return os.date('%a %H:%M')
end

local indent_style = function ()
  if vim.o.expandtab then
    return 'Spaces: ' .. vim.o.shiftwidth
  else
    if vim.o.tabstop == vim.o.shiftwidth then
      return 'Tabs: ' .. vim.o.tabstop
    else
      return 'Tabs: ' .. vim.o.tabstop .. vim.o.shiftwidth
    end
  end
end

lualine.setup {
  options = {
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    globalstatus = true and vim.o.laststatus == 3,
  },
 sections = {
   lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = ' [+]',
          readonly = ' [-]',
          unnamed = ''
        }
      }
    },
    lualine_x = {
      indent_style,
      'encoding',
      {
        'fileformat',
        symbols = {
          unix = ' Unix',
          dos = ' DOS',
          mac = ' Mac'
        }
      },
      'filetype'
    },
    lualine_y = {location, 'progress'},
    lualine_z = {clock}
  }
}
