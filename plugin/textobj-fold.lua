---Returns the key sequence to select around/inside a fold,
---supposed to be called in visual mode
---@param motion 'i'|'a'
---@return string
function _G.textobj_fold(motion)
  local lnum = vim.fn.line('.') --[[@as integer]]
  local sel_start = vim.fn.line('v')
  local foldlev = vim.fn.foldlevel(lnum)
  local foldlev_prev = vim.fn.foldlevel(lnum - 1)
  -- Multi-line selection with cursor on top of selection
  if sel_start > lnum then
    return (
      foldlev == 0 and 'zk'
      or (foldlev > foldlev_prev and foldlev_prev > 0 and 'k' or '')
    ) .. (motion == 'i' and ']zkV[zj' or ']zV[z')
  end
  return (foldlev == 0 and 'zj' or (foldlev > foldlev_prev and 'j' or ''))
    .. (motion == 'i' and '[zjV]zk' or '[zV]z')
end
-- stylua: ignore start
vim.keymap.set('x', 'iz', '":<C-u>silent! keepjumps normal! " . v:lua.textobj_fold("i") . "<CR>"', { silent = true, expr = true, noremap = false })
vim.keymap.set('x', 'az', '":<C-u>silent! keepjumps normal! " . v:lua.textobj_fold("a") . "<CR>"', { silent = true, expr = true, noremap = false })
vim.keymap.set('o', 'iz', '<Cmd>silent! normal Viz<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'az', '<Cmd>silent! normal Vaz<CR>', { silent = true, noremap = false })
-- stylua: ignore end
