local utils = require('colors.nvim-falcon.utils')
local plt = utils.reload('colors.nvim-falcon.palette')

local lualine_theme = {}

lualine_theme.dark = {
  inactive = {
    a = { fg = plt.smoke, bg = plt.ocean, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.ocean },
    c = { fg = plt.smoke, bg = plt.ocean },
  },
  normal = {
    a = { fg = plt.smoke, bg = plt.space, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.ocean },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
  visual = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
  replace = {
    a = { fg = plt.space, bg = plt.yellow, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
  insert = {
    a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
  terminal = {
    a = { fg = plt.space, bg = plt.turquoise, gui = 'bold' }
  },
  command = {
    a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
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
    a = { fg = plt.space, bg = plt.yellow, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
  replace = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
  insert = {
    a = { fg = plt.space, bg = plt.aqua, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
  terminal = {
    a = { fg = plt.space, bg = plt.turquoise, gui = 'bold' }
  },
  command = {
    a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder },
  },
}

return lualine_theme[vim.o.background or 'dark']
