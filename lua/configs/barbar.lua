require('bufferline').setup({
  auto_hide = true,
  tabpages = true,
  closable = true,
  clickable = true,
  icons = 'both',
  icon_custom_colors = false,
  icon_separator_active = '',
  icon_separator_inactive = '',
  icon_close_tab = '',
  icon_close_tab_modified = '[+]',
  icon_pinned = '',
  insert_at_end = true,
  insert_at_start = false,
  maximum_padding = 1,
  maximum_length = 30,
  semantic_letters = true,
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
  no_name_title = nil
})

local barbar_api = require('bufferline.api')
local function nnoremap(lhs, rhs)
  vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true })
end

nnoremap('<Tab>', function() barbar_api.goto_buffer_relative(1) end)
nnoremap('<S-Tab>', function() barbar_api.goto_buffer_relative(-1) end)
nnoremap('<M-.>', function() barbar_api.move_current_buffer(1) end)
nnoremap('<M-,>', function() barbar_api.move_current_buffer(-1) end)
-- goto buffer in position 1..9
for buf_number = 1, 9 do
  nnoremap(string.format('<M-%d>', buf_number), function()
    barbar_api.goto_buffer(buf_number)
  end)
end
nnoremap('<M-0>', function() barbar_api.goto_buffer(-1) end)
nnoremap('<M-(>', barbar_api.close_buffers_left)
nnoremap('<M-)>', barbar_api.close_buffers_right)
nnoremap('<M-P>', barbar_api.toggle_pin)
nnoremap('<M-O>', barbar_api.close_all_but_visible)
nnoremap('<M-C>', '<CMD>BufferClose<CR>')
