if vim.b.current_syntax ~= nil then
  vim.b.current_syntax = nil
end

-- Use vim.schedule to avoid freezing neovim when reloading markdown files
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  -- Need to use `nvim_buf_call()` else opening LSP hover window will
  -- mess up the syntax highlighting of current buffer, seems like
  -- a bug of neovim
  vim.api.nvim_buf_call(buf, function()
    -- Get good embedded code block syntax highlighting from treesitter
    -- and good math conceal from vimtex at the same time
    if not vim.b.midfile then
      pcall(vim.treesitter.start, buf, 'markdown')
    end
    if not vim.b.bigfile then
      vim.cmd.runtime('syntax/mkd.vim')
      vim.b[buf].current_syntax = 'mkd'
    end
  end)
end)
