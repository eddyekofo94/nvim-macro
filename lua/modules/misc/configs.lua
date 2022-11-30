local M = {}

M['nvim-surround'] = function()
  require('nvim-surround').setup()
end

M['Comment.nvim'] = function()
  require('Comment').setup({
    ignore = '^$',
  })
end

M['nvim-colorizer'] = function()
  require('colorizer').setup()
end

return M
