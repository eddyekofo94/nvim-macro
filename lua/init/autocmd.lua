-- -- Communication between Neovim in WSL & system clipboard
-- if vim.fn.has('wsl') then
--   vim.cmd [[
--     augroup Yank
--       autocmd!
--       autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe', @")
--     augroup END
--   ]]
-- end

-- `PackerSync` on save of `plugins.lua`
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Autosave on focus change
vim.cmd [[ autocmd BufLeave,FocusLost * silent! wall ]]
