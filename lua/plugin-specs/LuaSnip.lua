return {
  'L3MON4D3/LuaSnip',
  -- requires = {
  --   require('plugin-specs.nvim-cmp'),
  --   require('plugin-specs.vimtex'),
  --   require('plugin-specs.vim-markdown')
  -- },
  config = function()
    require('plugin-configs.LuaSnip')
  end,
}
