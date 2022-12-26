local handler_md2pdf = nil
local handler_viewer = nil

vim.api.nvim_buf_create_user_command(0, 'MarkdownToPDF', function()
  local fname_md = vim.fn.expand('%')
  local fname_pdf = string.format('%s.pdf', vim.fn.expand('%:r'))
  vim.cmd('write')
  handler_md2pdf = vim.loop.spawn('md2pdf', { args = { fname_md } }, function(code_md2pdf, _)
    if handler_md2pdf then
      handler_md2pdf:close()
    end
    if code_md2pdf ~= 0 then
      vim.notify(string.format('md2pdf failed with code %d', code_md2pdf), vim.log.levels.ERROR)
    else
      handler_viewer = vim.loop.spawn('okular', { args = { fname_pdf } }, function(code_viewer, _)
        if handler_viewer then
          handler_viewer:close()
        end
        if code_viewer ~= 0 then
          vim.notify(string.format('okular failed with code %d', code_viewer), vim.log.levels.ERROR)
        end
      end)
    end
  end)
end, { desc = 'Convert markdown to pdf' })
