local ot = require('otter')
local utils = require('utils')

ot.setup({
  buffers = {
    set_filetype = true,
  },
  lsp = {
    -- Use custom project root dir finder instead of nvim-lspconfig's
    -- this removes hard requirement of nvim-lspconfig for otter
    root_dir = utils.fs.proj_dir,
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

-- Use otter to provide completions in code blocks
local cmp_ok, cmp = pcall(require, 'cmp')
if cmp_ok then
  cmp.setup({
    sources = table.insert(
      require('cmp.config').get().sources,
      { name = 'otter' }
    ),
  })
end
