local mason_nvim_dap = require('mason-nvim-dap')
mason_nvim_dap.setup({
  ensure_installed = require('utils.static').langs:list('dap'),
  automatic_setup = true,
})
mason_nvim_dap.setup_handlers({
  python = function(_) end, -- suppress auto setup for python
})
