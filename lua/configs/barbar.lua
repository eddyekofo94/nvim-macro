require('bufferline').setup({
  auto_hide = true,
  tabpages = true,
  closable = true,
  clickable = true,
  icons = {
    buffer_index = true,
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = { enabled = false },
      [vim.diagnostic.severity.HINT] = { enabled = false },
      [vim.diagnostic.severity.INFO] = { enabled = false },
      [vim.diagnostic.severity.WARN] = { enabled = false },
    },
    separator = {
      left = '',
      right = '',
    },
    button = '',
    modified = { button = '[+]' },
    pinned = { button = '' },
    inactive = {
      separator = {
        left = '',
        right = '',
      },
    },
    scroll = {
      left = '',
      right = '',
    },
  },
  insert_at_end = true,
  insert_at_start = false,
  maximum_padding = 1,
  maximum_length = 30,
  semantic_letters = true,
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
  no_name_title = nil,
})

local barbar_api = require('bufferline.api')
local function nnoremap(lhs, rhs)
  vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true })
end

-- stylua: ignore start
nnoremap(']b', function() barbar_api.goto_buffer_relative(vim.v.count1) end)
nnoremap('[b', function() barbar_api.goto_buffer_relative(-vim.v.count1) end)
nnoremap('<M-.>', function() barbar_api.move_current_buffer(vim.v.count1) end)
nnoremap('<M-,>', function() barbar_api.move_current_buffer(-vim.v.count1) end)
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
-- stylua: ignore end
