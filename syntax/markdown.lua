if vim.b.current_syntax ~= nil then
  vim.b.current_syntax = nil
end

-- Use vim.schedule to avoid freezing neovim
-- when reloading markdown files
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
  vim.api.nvim_buf_call(buf, function()
    if not vim.api.nvim_buf_is_valid(buf) or vim.b[buf].large_file then
      return
    end
    -- Apply treesitter highlighting for better
    -- embedded code block syntax highlighting
    pcall(vim.treesitter.start, buf, 'markdown')
    -- Apply regex syntax rules to get math conceal
    -- provided by vimtex and url conceal
    vim.cmd.runtime('syntax/mkd.vim')
    vim.b[buf].current_syntax = 'mkd'
  end)
end)
