local tsj = require('treesj')

tsj.setup({
  use_default_keymaps = false,
  max_join_length = 1024,
})

---@param preset table?
---@return nil
function _G.tsj_split_recursive(_, preset)
  require('treesj.format')._format(
    'split',
    vim.tbl_deep_extend('force', preset or {}, {
      split = { recursive = true },
    })
  )
end

---@param preset table?
---@return nil
function _G.tsj_toggle_recursive(_, preset)
  require('treesj.format')._format(
    nil,
    vim.tbl_deep_extend('force', preset or {}, {
      split = { recursive = true },
      join = { recursive = true },
    })
  )
end

---@param dir string
---@return function
local function format_fn(dir)
  return function()
    vim.opt.operatorfunc = 'v:lua.tsj_' .. dir
    vim.api.nvim_feedkeys('g@l', 'nx', true)
  end
end

vim.keymap.set('n', '<Leader>j', tsj.join)
vim.keymap.set('n', '<Leader>J', tsj.join)
vim.keymap.set('n', '<Leader>s', tsj.split)
vim.keymap.set('n', '<Leader>t', tsj.toggle)
vim.keymap.set('n', '<Leader>S', format_fn('split_recursive'))
vim.keymap.set('n', '<Leader>T', format_fn('toggle_recursive'))
