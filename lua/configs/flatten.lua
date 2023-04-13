local ok, toggleterm = pcall(require, 'toggleterm')
if not ok then
  print('flatten: toggleterm not found')
  toggleterm = {
    toggle = function(_) end,
  }
end

require('flatten').setup({
  window = {
    open = 'alternate',
  },
  callbacks = {
    should_block = function(argv)
      return vim.tbl_contains(argv, '-b')
    end,
    post_open = function(_, winnr, _, is_blocking)
      if is_blocking then
        toggleterm.toggle(0)
      else
        vim.api.nvim_set_current_win(winnr)
      end
    end,
    block_end = function()
      toggleterm.toggle(0)
    end,
  },
})
