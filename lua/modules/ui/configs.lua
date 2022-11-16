local M = {}

M['nvim-web-devicons'] = function()
  require('nvim-web-devicons').setup({
    override = {
      default_icon = {
        color = '#b4b4b9',
        cterm_color = '249',
        icon = '',
        name = 'Default'
      },
      desktop = {
        color = '#563d7c',
        cterm_color = '60',
        icon = 'ﲾ',
        name = 'DesktopEntry'
      },
    },
  })
end

M['barbar.nvim'] = function()
  require('bufferline').setup({
    animation = false,
    auto_hide = true,
    tabpages = true,
    closable = true,
    clickable = true,
    icons = 'both',
    icon_custom_colors = false,
    icon_separator_active = '▌',
    icon_separator_inactive = '▌',
    icon_close_tab = '',
    icon_close_tab_modified = '[+]',
    icon_pinned = '車',
    insert_at_end = false,
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
  nnoremap('<M->>', function() barbar_api.move_current_buffer(1) end)
  nnoremap('<M-<>', function() barbar_api.move_current_buffer(-1) end)
  for buf_number = 1, 9 do
    -- goto buffer in position 1..9
    nnoremap(string.format('<M-%d>', buf_number),
            function() barbar_api.goto_buffer(buf_number) end)
  end
  nnoremap('<M-(>', barbar_api.close_buffers_left)
  nnoremap('<M-)>', barbar_api.close_buffers_right)
  nnoremap('<M-S>', barbar_api.pick_buffer)
  nnoremap('<M-P>', barbar_api.toggle_pin)
  nnoremap('<M-O>', barbar_api.close_all_but_visible)
  nnoremap('<M-C>', '<CMD>BufferClose<CR>')
end

M['lualine.nvim'] = function()

  local function location()
    local cursor_loc = vim.api.nvim_win_get_cursor(0)
    return cursor_loc[1] .. ',' .. cursor_loc[2] + 1
  end

  local function indent_style()
    -- Get softtabstop or equivalent fallback
    local sts
    if vim.bo.sts > 0 then
      sts = vim.bo.sts
    elseif vim.bo.sw > 0 then
      sts = vim.bo.sw
    else
      sts = vim.bo.ts
    end

    if vim.bo.expandtab then
      return 'Spaces: ' .. sts
    elseif vim.bo.ts == sts then
      return 'Tabs: ' .. vim.bo.tabstop
    else
      return 'Tabs: ' .. vim.bo.tabstop .. '/' .. sts
    end
  end

  require('lualine').setup({
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = true and vim.o.laststatus == 3,
      theme = require('colors.nvim-falcon.lualine.themes.nvim-falcon')
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          'filename',
          path = 3,
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '',
          },
        },
      },
      lualine_x = {
        indent_style,
        'encoding',
        {
          'fileformat',
          symbols = {
            unix = ' Unix',
            dos = ' DOS',
            mac = ' Mac'
          }
        },
        'filetype',
      },
      lualine_y = { location },
      lualine_z = { 'progress' },
    },
  })
end

return M
