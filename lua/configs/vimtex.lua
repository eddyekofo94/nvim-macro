vim.g.vimtex_format_enabled = 1
vim.g.vimtex_imaps_enabled = 0
vim.g.vimtex_mappings_prefix = '<LocalLeader>t'

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.api.nvim_eval('vimtex#init()')
    vim.api.nvim_eval('vimtex#text_obj#init_buffer()')
  end
})
