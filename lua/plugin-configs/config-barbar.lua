local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- -- Trying to resize offset of barbar automatically when size of 'nvim-tree' is changed
-- -- But `WinResized` or `WinLayoutChanged` has not be implemented yet
-- execute
-- [[
--   augroup TreeSetBarBar
--     autocmd!
--     autocmd WinResized,WinLayoutChanged * lua require('bufferline.state').set_offset(vim.fn.winwidth(require('nvim-tree.view').get_winnr())+1)
--   augroup END
-- ]]

BarbarShift = function ()
   local bb_ready, bb_st = pcall(require, 'bufferline.state')
   local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
   if bb_ready and tree_view_ready and tree_view.is_visible() then
     bb_st.set_offset(tree_view.View.width, 'NvimTree')
   elseif bb_ready then
     bb_st.set_offset(0)
   end
 end

vim.cmd [[ autocmd BufEnter * lua BarbarShift() ]]

-- Move to previous/next
map('n', '<S-Tab>', ':BufferPrevious<CR>', opts)
map('n', '<Tab>', ':BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<M-<>', ':BufferMovePrevious<CR>', opts)
map('n', '<M->>', ':BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<M-1>', ':BufferGoto 1<CR>', opts)
map('n', '<M-2>', ':BufferGoto 2<CR>', opts)
map('n', '<M-3>', ':BufferGoto 3<CR>', opts)
map('n', '<M-4>', ':BufferGoto 4<CR>', opts)
map('n', '<M-5>', ':BufferGoto 5<CR>', opts)
map('n', '<M-6>', ':BufferGoto 6<CR>', opts)
map('n', '<M-7>', ':BufferGoto 7<CR>', opts)
map('n', '<M-8>', ':BufferGoto 8<CR>', opts)
map('n', '<M-9>', ':BufferGoto 9<CR>', opts)
map('n', '<M-$>', ':BufferLast<CR>', opts)
-- Delete buffer
map('n', '<M-d>', ':BufferClose<CR>', opts) -- Similar but better than `:bd`
-- Pin/Unpin buffer
map('n', '<M-p>', ':BufferPin<CR>', opts)
-- Wipeout buffer
-- map('n', '???', ':BufferWipeout<CR>', opts)
-- Close commands
map('n', '<M-D>', ':BufferCloseAllButCurrentOrPinned<CR>', opts)
map('n', '<M-[>', ':BufferCloseBuffersLeft<CR>', opts)
map('n', '<M-]>', ':BufferCloseBuffersRight<CR>', opts)
-- Magic buffer-picking mode
map('n', '<M-s>', ':BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Leader>bb', ':BufferOrderByBufferNumber<CR>', opts)
map('n', '<Leader>bd', ':BufferOrderByDirectory<CR>', opts)
map('n', '<Leader>bl', ':BufferOrderByLanguage<CR>', opts)
-- Set barbar's options
vim.g.bufferline = {
  -- Enable/disable animations
  animation = false,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = 'both',

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▌',
  icon_separator_inactive = '▌',
  icon_close_tab = '',
  icon_close_tab_modified = '',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil
}

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
