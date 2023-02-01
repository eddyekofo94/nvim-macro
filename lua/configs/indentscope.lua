vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    if vim.bo.bt ~= '' then
      vim.b.miniindentscope_disable = true
    end
  end,
})
require('mini.indentscope').setup({
  symbol = '│',
  draw = { delay = 0 }
})
