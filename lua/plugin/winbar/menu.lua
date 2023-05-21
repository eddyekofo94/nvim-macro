local bar = require('plugin.winbar.bar')
local groupid = vim.api.nvim_create_augroup('WinBarMenu', {})

---Lookup table for winbar menus
---@type table<integer, winbar_menu_t>
_G.winbar.menus = {}

---@param value number
---@param min number
---@param max number
local function bound(value, min, max)
  -- In case min > max
  local lower_bound = math.min(min, max)
  local upper_bound = math.max(min, max)
  return math.min(math.max(value, lower_bound), upper_bound)
end

---@class winbar_menu_entry_t
---@field separator winbar_symbol_t
---@field padding {left: integer, right: integer}
---@field components winbar_symbol_t[]
---@field menu winbar_menu_t the menu the entry belongs to
local winbar_menu_entry_t = {}
winbar_menu_entry_t.__index = winbar_menu_entry_t

---Create a winbar menu entry instance
---@param opts winbar_menu_entry_t?
---@return winbar_menu_entry_t
function winbar_menu_entry_t:new(opts)
  local entry = setmetatable(
    vim.tbl_deep_extend('force', {
      separator = bar.winbar_symbol_t:new({
        icon = ' ',
        icon_hl = 'WinBarMenuSeparator',
      }),
      padding = {
        left = 1,
        right = 1,
      },
      components = {},
    }, opts),
    self
  )
  for _, component in ipairs(entry.components) do
    component.entry = entry
  end
  return entry
end

---Concatenate inside a winbar menu entry to get the final string
---and highlight information of the entry
---@return string str
---@return {start: integer, end: integer, hlgroup: string}[] hl_info
function winbar_menu_entry_t:cat()
  local components_with_sep = {} ---@type winbar_symbol_t[]
  for component_idx, component in ipairs(self.components) do
    if component_idx > 1 then
      table.insert(components_with_sep, self.separator)
    end
    table.insert(components_with_sep, component)
  end
  local str = ''
  local hl_info = {}
  for _, component in ipairs(components_with_sep) do
    if component.icon_hl then
      table.insert(hl_info, {
        start = #str,
        ['end'] = #str + #component.icon,
        hlgroup = component.icon_hl,
      })
    end
    if component.name_hl then
      table.insert(hl_info, {
        start = #str + #component.icon + 1,
        ['end'] = #str + #component.icon + #component.name + 1,
        hlgroup = component.name_hl,
      })
    end
    str = str .. component:cat(true)
  end
  return string.rep(' ', self.padding.left) .. str .. string.rep(
    ' ',
    self.padding.right
  ),
    hl_info
end

---Get the display length of the winbar menu entry
---@return number
function winbar_menu_entry_t:displaywidth()
  return vim.fn.strdisplaywidth((self:cat()))
end

---@class winbar_menu_opts_t
---@field is_open boolean?
---@field entries winbar_menu_entry_t[]?
---@field win_configs table? window configuration
---@field cursor integer[]? initial cursor position
---@field prev_win integer? previous window

---@class winbar_menu_t
---@field is_open boolean?
---@field entries winbar_menu_entry_t[]
---@field win_configs table window configuration
---@field cursor integer[]? initial cursor position
---@field prev_win integer? previous window, assigned when calling new() or automatically determined in open()
---@field sub_menu winbar_menu_t? submenu, assigned when calling new() or automatically determined when a new menu opens
---@field parent_menu winbar_menu_t? parent menu, assigned when calling new() or automatically determined in open()
local winbar_menu_t = {}
winbar_menu_t.__index = winbar_menu_t

---Create a winbar menu instance
---@param opts winbar_menu_opts_t?
---@return winbar_menu_t
function winbar_menu_t:new(opts)
  local winbar_menu = setmetatable(
    vim.tbl_deep_extend('force', {
      entries = {},
      win_configs = {
        ---@param this winbar_menu_t
        row = function(this)
          return this.parent_menu and this.parent_menu.win_configs.row[false]
            or 1
        end,
        col = function(this)
          return this.parent_menu and this.parent_menu.win_configs.width or 0
        end,
        relative = function(this)
          return this.parent_menu and 'win' or 'mouse'
        end,
        border = 'none',
        style = 'minimal',
        height = function(this)
          return bound(
            #this.entries,
            2,
            vim.go.pumheight ~= 0 and vim.go.pumheight
              or math.floor(vim.go.lines / 4)
          )
        end,
        width = function(this)
          local entry_lengths = vim.tbl_map(function(entry)
            return entry:displaywidth()
          end, this.entries)
          if vim.tbl_isempty(entry_lengths) then
            return vim.go.pumwidth
          end
          return bound(
            math.max(unpack(entry_lengths)),
            vim.go.pumwidth,
            math.floor(vim.go.columns / 4)
          )
        end,
      },
    }, opts or {}),
    winbar_menu_t
  )
  for _, entry in ipairs(winbar_menu.entries) do
    entry.menu = winbar_menu
  end
  return winbar_menu
end

---Delete a winbar menu
---@return nil
function winbar_menu_t:del()
  if self.sub_menu then
    self.sub_menu:del()
    self.sub_menu = nil
  end
  self:close()
  if self.buf then
    vim.api.nvim_buf_delete(self.buf, {})
    self.buf = nil
  end
end

---Evaluate window configurations
---@see vim.api.nvim_open_win
function winbar_menu_t:eval_win_config()
  -- Evaluate function-valued window configurations
  for k, config in pairs(self.win_configs) do
    if type(config) == 'function' then
      self.win_configs[k] = config(self)
    end
  end
  return self.win_configs
end

---Get the component at the given position in the winbar menu
---@param pos integer[] {row: integer, col: integer}, 1-indexed
---@return winbar_symbol_t?
function winbar_menu_t:get_component_at(pos)
  if not self.entries or vim.tbl_isempty(self.entries) then
    return nil
  end
  local row = pos[1]
  local col = pos[2]
  local entry = self.entries[row]
  if not entry or not entry.components then
    return nil
  end
  local col_offset = entry.padding.left
  for _, component in ipairs(entry.components) do
    local component_len = component:displaywidth()
    if col > col_offset and col <= col_offset + component_len then
      return component
    end
    col_offset = col_offset + component_len
  end
  return nil
end

---Make a buffer for the menu and set buffer-local keymaps
---Must be called after the popup window is created
---Side effect: change self.buf
---@return nil
function winbar_menu_t:make_buf()
  if self.buf then
    return
  end
  self.buf = vim.api.nvim_create_buf(false, true)
  local lines = {} ---@type string[]
  local hl_info = {} ---@type {start: integer, end: integer, hlgroup: string}[][]
  for _, entry in ipairs(self.entries) do
    local line, entry_hl_info = entry:cat()
    -- Pad the line with spaces to the width of the window
    -- This is to make sure hl-WinBarMenuCurrentContext colors
    -- the entire line
    table.insert(
      lines,
      line
        .. string.rep(
          ' ',
          self.win_configs.width - vim.fn.strdisplaywidth(line)
        )
    )
    table.insert(hl_info, entry_hl_info)
  end
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
  for entry_idx, entry_hl_info in ipairs(hl_info) do
    for _, hl in ipairs(entry_hl_info) do
      vim.api.nvim_buf_add_highlight(
        self.buf,
        -1,
        hl.hlgroup,
        entry_idx - 1, -- 0-indexed
        hl.start,
        hl['end']
      )
    end
    if self.cursor and entry_idx == self.cursor[1] then
      vim.api.nvim_buf_add_highlight(
        self.buf,
        -1,
        'WinBarMenuCurrentContext',
        entry_idx - 1, -- 0-indexed
        0,
        -1
      )
    end
  end
  vim.bo[self.buf].ma = false
  vim.bo[self.buf].ft = 'winbar_menu'

  -- Set buffer-local keymaps
  vim.keymap.set({ 'x', 'n' }, '<LeftMouse>', function()
    local mouse = vim.fn.getmousepos()
    if mouse.winid ~= self.win then
      local parent_menu = _G.winbar.menus[mouse.winid]
      if parent_menu and parent_menu.sub_menu then
        parent_menu.sub_menu:close()
      end
      if vim.api.nvim_win_is_valid(mouse.winid) then
        vim.api.nvim_set_current_win(mouse.winid)
      end
      return
    end
    local component = self:get_component_at({ mouse.winrow, mouse.wincol })
    vim.api.nvim_win_set_cursor(mouse.winid, { mouse.winrow, mouse.wincol })
    if component and component.on_click then
      component:on_click(0, 1, 'l', '')
    end
  end, { buffer = self.buf })
  vim.keymap.set({ 'x', 'n' }, 'q', function()
    self:close()
  end, { buffer = self.buf })

  -- Set buffer-local autocmds
  vim.api.nvim_create_autocmd('WinClosed', {
    group = groupid,
    buffer = self.buf,
    callback = function()
      -- Trigger self:close() when the popup window is closed
      -- to ensure the cursor is set to the correct previous window
      self:close()
    end,
  })
end

---Open the menu
---Side effect: change self.win and self.buf
---@return nil
function winbar_menu_t:open()
  if self.is_open then
    return
  end
  self.is_open = true

  self.prev_win = self.prev_win or vim.api.nvim_get_current_win()
  local parent_menu = _G.winbar.menus[self.prev_win]
  if parent_menu then
    parent_menu.sub_menu = self
    self.parent_menu = parent_menu
  end

  self:eval_win_config()
  self:make_buf()
  self.win = vim.api.nvim_open_win(self.buf, true, self.win_configs)
  self.win_configs = vim.api.nvim_win_get_config(self.win)
  vim.wo[self.win].scrolloff = 0
  vim.wo[self.win].sidescrolloff = 0
  _G.winbar.menus[self.win] = self
  -- Initialize cursor position
  if self.win_configs.focusable ~= false and self.cursor then
    vim.api.nvim_win_set_cursor(self.win, self.cursor)
  end
end

---Close the menu
---@return nil
function winbar_menu_t:close()
  if not self.is_open then
    return
  end
  if self.sub_menu then
    self.sub_menu:close()
  end
  self.is_open = false
  if self.win and vim.api.nvim_win_is_valid(self.prev_win) then
    vim.api.nvim_set_current_win(self.prev_win)
  end
  _G.winbar.menus[self.win] = nil
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
end

---Toggle the menu
---@return nil
function winbar_menu_t:toggle()
  if self.is_open then
    self:close()
  else
    self:open()
  end
end

return {
  winbar_menu_t = winbar_menu_t,
  winbar_menu_entry_t = winbar_menu_entry_t,
}
