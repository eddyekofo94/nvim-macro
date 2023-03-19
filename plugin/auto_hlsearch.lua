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
  if vim.fn.mode() == 'n' then
    if searchkeys[vim.fn.keytrans(char)] then
      vim.opt.hlsearch = true
    end
  end
end, vim.api.nvim_create_namespace('auto_hlsearch'))

vim.keymap.set('n', '\\', '<Cmd>set hlsearch!<CR>', { noremap = true })

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  command = 'set nohlsearch'
})
