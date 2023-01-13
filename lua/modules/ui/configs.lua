local M = {}

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
  nnoremap('<M-.>', function() barbar_api.move_current_buffer(1) end)
  nnoremap('<M-,>', function() barbar_api.move_current_buffer(-1) end)
  for buf_number = 1, 9 do
    -- goto buffer in position 1..9
    nnoremap(string.format('<M-%d>', buf_number),
            function() barbar_api.goto_buffer(buf_number) end)
  end
  nnoremap('<M-0>', function() barbar_api.goto_buffer(-1) end)
  nnoremap('<M-(>', barbar_api.close_buffers_left)
  nnoremap('<M-)>', barbar_api.close_buffers_right)
  nnoremap('<M-P>', barbar_api.toggle_pin)
  nnoremap('<M-O>', barbar_api.close_all_but_visible)
  nnoremap('<M-C>', '<CMD>BufferClose<CR>') -- equivalent to :bufdo bwipeout
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

  local function searchcount()
    local info = vim.fn.searchcount({ maxcount = 999 })
    if not vim.o.hlsearch then
      return ''
    end
    if info.incomplete == 1 then  -- timed out
      return '[?/??]'
    end
    if info.total == 0 then
      return ''
    end
    if info.current > info.maxcount then
      info.current = '>' .. info.maxcount
    end
    if info.total > info.maxcount then
      info.total = '>' .. info.maxcount
    end
    return string.format('[%s/%s]', info.current, info.total)
  end

  local lualine_theme = require('colors.nvim-falcon.lualine.themes.nvim-falcon')
  local palette = require('colors.nvim-falcon.palette')

  local function lsp_info()
    local lsp_names = vim.tbl_map(function(client_info)
      return client_info.name
    end, vim.lsp.get_active_clients({
      bufnr = vim.api.nvim_get_current_buf()
    }))

    if #lsp_names == 0 then
      return ''
    else
      vim.api.nvim_set_hl(0, 'LSPServerIcon',
        { fg = palette.lavender, bg = lualine_theme.normal.c.bg })
      return '%#LSPServerIcon# %*LSP: ' .. table.concat(lsp_names, ', ')
    end
  end

  local function reg_recording()
    local reg = vim.fn.reg_recording()
    if vim.fn.empty(reg) == 0 then
      return 'recording @' .. reg
    end
    return ''
  end

  vim.api.nvim_set_hl(0, 'TuxIcon',
    { fg = palette.yellow,
      bg = lualine_theme.normal.c.bg })
  vim.api.nvim_set_hl(0, 'WindowsIcon',
    { fg = palette.skyblue,
      bg = lualine_theme.normal.c.bg })
  vim.api.nvim_set_hl(0, 'OSXIcon',
    { fg = palette.ochre,
      bg = lualine_theme.normal.c.bg })
  require('lualine').setup({
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = true and vim.o.laststatus == 3,
      theme = lualine_theme
    },
    extensions = { 'aerial' },
    sections = {
      lualine_a = { 'mode', reg_recording },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        {
          'filename',
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
            unix = '%#TuxIcon# %*Unix',
            dos = '%#WindowsIcon# %*DOS',
            mac = '%#OSXIcon# %*Mac'
          }
        },
        'filetype',
        lsp_info,
      },
      lualine_y = { searchcount, location },
      lualine_z = { 'progress' },
    },
  })
end

M['alpha-nvim'] = function()
  local alpha = require('alpha')
  local dashboard = require('alpha.themes.dashboard')
  local headers = require('utils.static').ascii_art

  local function make_button(usr_opts, txt, keybind, keybind_opts)
    local sc_after = usr_opts.shortcut:gsub('%s', '')
    local default_opts = {
      position = 'center',
      cursor = 5,
      width = 50,
      align_shortcut = 'right',
      hl_shortcut = 'Keyword'
    }
    local opts = vim.tbl_deep_extend('force', default_opts, usr_opts)
    if nil == keybind then
      keybind = sc_after
    end
    keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { 'n', sc_after, keybind, keybind_opts }

    local function on_press()
      -- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
      local key = vim.api.nvim_replace_termcodes(sc_after .. '<Ignore>', true, false, true)
      vim.api.nvim_feedkeys(key, 't', false)
    end

    return {
      type = 'button',
      val = txt,
      on_press = on_press,
      opts = opts,
    }
  end

  math.randomseed(os.time())
  dashboard.section.header.val = headers[math.random(1, #headers)]
  dashboard.section.header.opts.hl = 'White'

  local dashboard_button_opts = {
    { { shortcut = 'e', hl = { { 'Tea', 2, 3 } } }, 'ﱐ  New file', '<cmd>ene<CR>' },
    { { shortcut = 's', hl = { { 'Pigeon', 2, 3 } } }, '  Sync plugins', '<cmd>PackerSync<CR>' },
    { { shortcut = 'i', hl = { { 'Ochre', 2, 3 } } }, '  Git', '<cmd>ToggleTool lazygit<CR>' },
    { { shortcut = 'f f', hl = { { 'Flashlight', 2, 3 } } }, '  Find files', '<cmd>Telescope find_files<CR>' },
    { { shortcut = 'f o', hl = { { 'Smoke', 2, 3 } } }, '  Old files', '<cmd>Telescope oldfiles<CR>' },
    { { shortcut = 'f m', hl = { { 'Earth', 2, 3 } } }, '  Goto bookmark', '<cmd>Telescope marks<CR>' },
    { { shortcut = 'f ;', hl = { { 'White', 2, 3 } } }, '  Live grep', '<cmd>Telescope live_grep<CR>' },
    { { shortcut = 'q', hl = { { 'Wine', 2, 3 } } }, '  Quit', '<cmd>qa<CR>' },
  }
  dashboard.section.buttons.val = {}
  for _, button in ipairs(dashboard_button_opts) do
    table.insert(dashboard.section.buttons.val, make_button(unpack(button)))
  end

  local function get_num_plugins_loaded()
    local num = 0
    for _, plugin in pairs(packer_plugins) do
      if plugin.loaded then
        num = num + 1
      end
    end
    return num
  end

  -- Footer must be a table so that its height is correctly measured
  local num_plugins_loaded = get_num_plugins_loaded()
  local num_plugins_tot = #vim.tbl_keys(packer_plugins)
  dashboard.section.footer.val = { string.format('%d / %d  plugins ﮣ loaded',
                                  num_plugins_loaded, num_plugins_tot) }
  dashboard.section.footer.opts.hl = 'Comment'

  -- Set paddings
  local h_header = #dashboard.section.header.val
  local h_buttons = #dashboard.section.buttons.val * 2 - 1
  local h_footer = #dashboard.section.footer.val
  local pad_tot = vim.o.lines - (h_header + h_buttons + h_footer)
  local pad_1 = math.ceil(pad_tot * 0.25)
  local pad_2 = math.ceil(pad_tot * 0.20)
  local pad_3 = math.floor(pad_tot * 0.20)
  dashboard.config.layout = {
    { type = 'padding', val = pad_1 },
    dashboard.section.header,
    { type = 'padding', val = pad_2 },
    dashboard.section.buttons,
    { type = 'padding', val = pad_3 },
    dashboard.section.footer
  }

  alpha.setup(dashboard.opts)

  -- Do not show statusline or tabline in alpha buffer
  vim.api.nvim_create_augroup('AlphaSetLine', {})
  vim.api.nvim_create_autocmd('User', {
    pattern = 'AlphaReady',
    callback = function()
      if vim.fn.winnr('$') == 1 then
        vim.t.laststatus_save = vim.o.laststatus
        vim.t.showtabline_save = vim.o.showtabline
        vim.o.laststatus = 0
        vim.o.showtabline = 0
      end
    end,
    group = 'AlphaSetLine',
  })
  vim.api.nvim_create_autocmd('BufUnload', {
    pattern = '*',
    callback = function()
      if vim.bo.ft == 'alpha' then
        vim.o.laststatus = vim.t.laststatus_save
        vim.o.showtabline = vim.t.showtabline_save
      end
    end,
    group = 'AlphaSetLine',
  })
end

return M
