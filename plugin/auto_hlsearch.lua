-- automatically set and unset hlsearch

local searchkeys = {
  ['n'] = true,
  ['N'] = true,
  ['*'] = true,
  ['#'] = true,
  ['?'] = true,
  ['/'] = true,
}

vim.on_key(function(char)
  if vim.fn.mode() == 'n' and searchkeys[vim.fn.keytrans(char)] then
    vim.opt.hlsearch = true
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))

vim.keymap.set('n', '<C-l>', '<Cmd>set nohlsearch<CR><C-l>')

vim.api.nvim_create_augroup('AutoHlSearch', { clear = true })
vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  group = 'AutoHlSearch',
  command = 'set nohlsearch',
})
