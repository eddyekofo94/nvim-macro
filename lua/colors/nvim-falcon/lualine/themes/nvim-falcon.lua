local plt = require('colors.nvim-falcon.palette')

local nvim_falcon = {
  inactive = {
    a = { fg = plt.smoke, bg = plt.iron, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.iron },
    c = { fg = plt.smoke, bg = plt.iron },
  },
  normal = {
    a = { fg = plt.smoke, bg = plt.space, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.iron },
    c = { fg = plt.smoke, bg = plt.deepsea },
  },
  visual = {
    a = { fg = plt.space, bg = plt.orange, gui = 'bold' },
    b = { fg = plt.smoke, bg = plt.thunder }
  },
  replace = { a = { fg = plt.space, bg = plt.yellow, gui = 'bold' } },
  insert = { a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' }, b = { fg = plt.white, bg = plt.steel } },
  terminal = { a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' } },
  command = { a = { fg = plt.space, bg = plt.flashlight, gui = 'bold' } }
}

return nvim_falcon
