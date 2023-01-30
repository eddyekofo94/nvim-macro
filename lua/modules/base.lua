local configs = require('modules.base.configs')

return {
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },

  {
    'kyazdani42/nvim-web-devicons',
    lazy = true,
    config = configs['nvim-web-devicons'],
  },
}
