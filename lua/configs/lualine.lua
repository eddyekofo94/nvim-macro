local palette = require('colors.cockatoo.palette')
local icons = require('utils.static').icons

vim.opt.rtp:append(vim.fn.stdpath('config') .. '/lua/colors/cockatoo')

---Lualine configuration
local function lualine_config()
  local function location()
    local cursor_loc = vim.api.nvim_win_get_cursor(0)
    return cursor_loc[1] .. ',' .. cursor_loc[2] + 1
  end

  ---Display indent style
  ---@return string
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
      return icons.Dot .. sts
    elseif vim.bo.ts == sts then
      return icons.ArrowRight .. vim.bo.tabstop
    else
      return icons.ArrowRight .. vim.bo.tabstop .. ' ' .. icons.Dot .. sts
    end
  end

  ---Display search count
  ---@return string
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

  package.loaded['colors.cockatoo.palette'] = nil
  local current_lsp_clients = {} -- cache for lsp clients

  ---Update attached lsp clients
  local function lsp_info_updater()
    current_lsp_clients = vim.lsp.get_active_clients({
      bufnr = vim.api.nvim_get_current_buf(),
    })
    return ''
  end

  ---Display a formatter icon if format on save is enabled
  ---@return string icon
  local function formatter_icon()
    if
      vim.b.lsp_format_on_save == false
      or not vim.b.lsp_format_on_save and not vim.g.lsp_format_on_save
    then
      return ''
    end

    for _, client in ipairs(current_lsp_clients) do
      if client.supports_method('textDocument/formatting') then
        return icons['Format']
      end
    end
    return ''
  end

  ---Display a message if format on save is enabled
  ---@return string message
  local function formatter_text()
    if
      vim.b.lsp_format_on_save == false
      or not vim.b.lsp_format_on_save and not vim.g.lsp_format_on_save
    then
      return ''
    end

    for _, client in ipairs(current_lsp_clients) do
      if client.supports_method('textDocument/formatting') then
        return 'auto-format'
      end
    end
    return ''
  end

  ---Display a connected icon if an LS is attached to current buffer
  ---@return string icon
  local function lsp_icon()
    if not vim.tbl_isempty(current_lsp_clients) then
      return icons['Lsp']
    end
    return ''
  end

  ---Display the names of attached LSs
  ---@return string names
  local function lsp_list()
    local lsp_names = vim.tbl_map(function(client_info)
      return client_info.name
    end, current_lsp_clients)

    if #lsp_names == 0 then
      return ''
    else
      return table.concat(lsp_names, ', ')
    end
  end

  ---Display a message if a macro is recording
  ---@return string message
  local function reg_recording()
    local reg = vim.fn.reg_recording()
    if vim.fn.empty(reg) == 0 then
      return 'recording @' .. reg
    end
    return ''
  end

  ---Get a function that returns true if the window width is longer than len
  ---@param len number
  ---@return function
  local function longer_than(len)
    return function()
      return vim.o.columns > len
    end
  end

  ---Get a function that returns true if the window width is shorter than len
  ---@param len number
  ---@return function
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
    },
    extensions = { 'aerial' },
    sections = {
      lualine_a = {
        'mode',
        {
          reg_recording,
          color = { fg = palette.space, bg = palette.orange, gui = 'bold' },
          cond = function()
            return vim.o.cmdheight == 0
          end,
        },
      },
      lualine_b = {
        {
          'branch',
          icon = {
            vim.trim(icons.GitBranch),
            color = { fg = palette.turquoise },
          },
        },
        {
          'diff',
          cond = longer_than(50),
          diff_color = {
            added = { fg = palette.tea },
            modified = { fg = palette.lavender },
            removed = { fg = palette.scarlet },
          },
          padding = { left = 0, right = 1 },
        },
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
          cond = longer_than(75),
        },
        {
          lsp_info_updater,
        },
        {
          formatter_icon,
          cond = longer_than(75),
          color = { fg = palette.ochre },
          padding = { left = 1, right = 0 },
        },
        {
          formatter_text,
          cond = longer_than(120),
        },
        {
          lsp_icon,
          cond = longer_than(75),
          color = { fg = palette.lavender },
        },
        {
          lsp_list,
          cond = longer_than(110),
          padding = { left = 0, right = 1 },
        },
      },
      lualine_y = {
        {
          searchcount,
          padding = { left = 1, right = 0 },
          cond = function()
            return vim.o.cmdheight == 0
          end,
        },
        location,
      },
      lualine_z = { 'progress' },
    },
  })
end

lualine_config()

vim.api.nvim_create_augroup('LuaLineReloadConfig', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  group = 'LuaLineReloadConfig',
  callback = lualine_config,
})
