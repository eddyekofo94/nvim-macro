vim.opt.rtp:append(vim.fn.stdpath('config') .. '/lua/colors/nvim-falcon')

local function lualine_config()
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
      return '• ' .. sts
    elseif vim.bo.ts == sts then
      return '⟼ ' .. vim.bo.tabstop
    else
      return '⟼ ' .. vim.bo.tabstop .. ' • ' .. sts
    end
  end

  local function searchcount()
    local info = vim.fn.searchcount({ maxcount = 999 })
    if not vim.o.hlsearch then
      return ''
    end
    if info.incomplete == 1 then -- timed out
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

  local utils = require('colors.nvim-falcon.utils')
  local palette = utils.reload('colors.nvim-falcon.palette')

  local function lsp_icon()
    if #vim.lsp.get_active_clients({
      bufnr = vim.api.nvim_get_current_buf()
    }) > 0 then
      return ' '
    end
    return ''
  end

  local function lsp_list()
    local lsp_names = vim.tbl_map(function(client_info)
      return client_info.name
    end, vim.lsp.get_active_clients({
      bufnr = vim.api.nvim_get_current_buf()
    }))

    if #lsp_names == 0 then
      return ''
    else
      return table.concat(lsp_names, ', ')
    end
  end

  local function reg_recording()
    local reg = vim.fn.reg_recording()
    if vim.fn.empty(reg) == 0 then
      return 'recording @' .. reg
    end
    return ''
  end

  local function longer_than(len)
    return function()
      return vim.o.columns > len
    end
  end

  local function shorter_than(len)
    return function()
      return vim.o.columns <= len
    end
  end

  require('lualine').setup({
    options = {
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = vim.o.laststatus == 3,
      theme = 'nvim-falcon',
    },
    extensions = { 'aerial' },
    sections = {
      lualine_a = {
        'mode',
        {
          reg_recording,
          color = { fg = palette.space, bg = palette.orange, gui = 'bold' },
          cond = function() return vim.o.cmdheight == 0 end,
        },
      },
      lualine_b = {
        { 'branch', icon = { '', color = { fg = palette.turquoise } } },
        { 'diff', cond = longer_than(50), padding = { left = 0, right = 1 } },
        { 'diagnostics', cond = longer_than(50) },
      },
      lualine_c = {
        {
          'filetype',
          icon_only = true,
          padding = { left = 1, right = 0 },
        },
        {
          'filename',
          path = 1,
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '',
          },
          cond = longer_than(115),
        },
        {
          'filename',
          symbols = {
            modified = '[+]',
            readonly = '[-]',
            unnamed = '',
          },
          cond = shorter_than(115),
        },
      },
      lualine_x = {
        { indent_style, cond = longer_than(60) },
        { 'encoding', cond = longer_than(85) },
        {
          'fileformat',
          symbols = {
            unix = 'Unix',
            dos = 'DOS',
            mac = 'Mac',
          },
          cond = longer_than(70),
        },
        {
          lsp_icon,
          cond = longer_than(70),
          color = { fg = palette.lavender }
        },
        {
          lsp_list,
          cond = longer_than(105),
          padding = { left = 0, right = 1 }
        },
      },
      lualine_y = {
        {
          searchcount,
          padding = { left = 1, right = 0 },
          cond = function() return vim.o.cmdheight == 0 end,
        },
        location
      },
      lualine_z = { 'progress' },
    },
  })
end

lualine_config()

vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = lualine_config,
})