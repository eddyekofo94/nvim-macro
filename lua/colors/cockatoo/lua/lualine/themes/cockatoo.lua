local plt = require('colors.cockatoo.palette')

local lualine_theme = {}

lualine_theme.dark = {
  inactive = {
    a = { fg = plt.smoke, bg = plt.ocean, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.ocean },
    c = { fg = plt.smoke, bg = plt.ocean },
  },
  normal = {
    a = { fg = plt.space, bg = plt.turquoise, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.deepsea },
    c = { fg = plt.smoke, bg = plt.ocean },
  },
  visual = {
    a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
  replace = {
    a = { fg = plt.space, bg = plt.yellow, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
  insert = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
  terminal = {
    a = { fg = plt.space, bg = plt.ochre, gui = 'bold' },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
  command = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
}

lualine_theme.light = {
  inactive = {
    a = { fg = plt.space, bg = plt.smoke, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.ocean },
    c = { fg = plt.smoke, bg = plt.ocean },
  },
  normal = {
    a = { fg = plt.space, bg = plt.smoke, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.deepsea },
    c = { fg = plt.smoke, bg = plt.ocean },
  },
  visual = {
    a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' },
  },
  replace = {
    a = { fg = plt.space, bg = plt.yellow, gui = 'bold' },
  },
  insert = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
  },
  terminal = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
  },
  command = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
  },
}

return lualine_theme[vim.o.background or 'dark']
