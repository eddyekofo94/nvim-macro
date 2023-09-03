local nsc = require('neoscroll')

nsc.setup({
  hide_cursor = false,
  mappings = {},
  pre_hook = function()
    vim.g.eventignore = vim.o.eventignore
    vim.opt.eventignore:append({
      'WinScrolled',
      'CursorMoved',
    })
  end,
  post_hook = function()
    if vim.g.eventignore then
      vim.o.eventignore = vim.g.eventignore
      vim.g.eventignore = nil
    end
  end,
})

---@param number integer integer > 0
---@return number
local function not2(number)
  return number == 2 and 1 or number
end

-- stylua: ignore start
-- nsc.scroll(2, ...) cause a bug: extremely slow scrolling
vim.keymap.set({ 'n', 'x' }, '<C-e>', function() nsc.scroll(not2(vim.v.count1), false, 0) end)
vim.keymap.set({ 'n', 'x' }, '<C-y>', function() nsc.scroll(not2(-vim.v.count1), false, 0) end)
vim.keymap.set({ 'n', 'x' }, '<C-d>', function() if vim.v.count ~= 0 then vim.opt_local.scr = math.min(vim.api.nvim_win_get_height(0), vim.v.count) end nsc.scroll(not2(vim.wo.scr), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<C-u>', function() if vim.v.count ~= 0 then vim.opt_local.scr = math.min(vim.api.nvim_win_get_height(0), vim.v.count) end nsc.scroll(-not2(vim.wo.scr), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<C-f>', function() nsc.scroll(vim.v.count1 * not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<C-b>', function() nsc.scroll(vim.v.count1 * -not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<S-Up>', function() nsc.scroll(vim.v.count1 * -not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<S-Down>', function() nsc.scroll(vim.v.count1 * not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<PageUp>', function() nsc.scroll(vim.v.count1 * -not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<PageDown>', function() nsc.scroll(vim.v.count1 * not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<S-PageUp>', function() nsc.scroll(vim.v.count1 * -not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, '<S-PageDown>', function() nsc.scroll(vim.v.count1 * not2(vim.api.nvim_win_get_height(0)), true, 0) end)
vim.keymap.set({ 'n', 'x' }, 'zt', function() nsc.zt(40) end)
vim.keymap.set({ 'n', 'x' }, 'zz', function() nsc.zz(40) end)
vim.keymap.set({ 'n', 'x' }, 'zb', function() nsc.zb(40) end)
-- stylua: ignore end
