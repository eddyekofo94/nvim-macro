return {
  {
    'j-hui/fidget.nvim',
    branch = 'legacy',
    event = 'FileType',
    config = function()
      require('configs.fidget')
    end,
  },
}
