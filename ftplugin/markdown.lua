local handler_md2pdf = nil

vim.api.nvim_buf_create_user_command(
  0, 'MarkdownToPDF', function ()
    local fname_md = vim.fn.expand('%')
    local fname_pdf = string.format('%s.pdf', vim.fn.expand('%:r'))
    vim.cmd('write')
    handler_md2pdf = vim.loop.spawn(
      'md2pdf',   -- under ~/.scripts, should be append to $PATH
      { args = { fname_md } },
      function(code, _)
        if handler_md2pdf then
          handler_md2pdf:close()
        end
        if code ~= 0 then
          vim.notify(string.format('md2pdf failed with code %d', code))
        else
          os.execute(string.format('okular %s', fname_pdf))
        end
      end
    )
  end,
  { desc = 'Convert markdown to pdf' }
)
