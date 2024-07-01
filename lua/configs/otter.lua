local ot = require('otter')
local utils = require('utils')

ot.setup({
  buffers = {
    set_filetype = true,
  },
  lsp = {
    root_dir = function()
      return vim.fs.root(0, utils.fs.root_patterns) or vim.fn.getcwd(0)
    end,
  },
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Activate otter for filetypes with injections.',
  group = vim.api.nvim_create_augroup('OtterActivate', {}),
  pattern = { 'markdown', 'norg', 'org' },
  callback = function(info)
    local buf = info.buf
    if vim.bo[buf].ma and utils.treesitter.is_active(buf) then
      -- Enable completion only, disable diagnostics
      ot.activate({ 'python', 'bash', 'lua' }, true, false)
    end
  end,
})
