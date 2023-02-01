require('fidget').setup({
  text = { spinner = 'dots' },
  fmt = {
    fidget = function(fidget_name, spinner)
      if string.match(vim.api.nvim_get_mode().mode, 'i.?') then return nil end
      return string.format('%s %s', spinner, fidget_name)
    end,
    task = function(_) return nil end,
  },
})
