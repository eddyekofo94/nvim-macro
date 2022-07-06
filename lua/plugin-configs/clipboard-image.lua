require('clipboard-image').setup {
  -- Default configuration for all filetype
  default = {
    img_dir = { '%:p:h', 'pic', '%:p:t:r' },
    img_dir_txt = 'pic/' .. vim.fn.expand('%:p:t:r'),
    img_name = function()
      vim.fn.inputsave()
      local name = vim.fn.input('Name: ')
      vim.fn.inputrestore()
      if name == nil or name == '' then
        return os.date('%y-%m-%d-%H-%M-%S')
      end
      return name
    end,
  },
  markdown = {
    affix = [[<center><img src='%s' alt='' style='zoom: 80%%'/></center>]],
    img_handler = function(img)
      vim.cmd('normal! 2f=l') -- go to 2nd `=` and then move right
      vim.cmd('normal! a' .. img.name)
    end
  }
}
