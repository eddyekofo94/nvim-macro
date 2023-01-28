local M = {}

M.twilight_exclude = {
  'markdown',
  'tex',
}

function M.limelight_check()
  if vim.g.twilight_active
      and vim.tbl_contains(M.twilight_exclude, vim.bo.ft) then
    vim.cmd('silent! Limelight')
  else
    vim.cmd('silent! Limelight!')
  end
end

return M
