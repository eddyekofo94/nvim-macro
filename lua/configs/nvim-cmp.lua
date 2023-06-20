local cmp = require('cmp')
local luasnip = require('luasnip')
local tabout = require('plugin.tabout')
local icons = require('utils.static').icons

---Choose the closer destination between two destinations
---@param dest1 number[]?
---@param dest2 number[]?
---@return number[]|nil
local function choose_closer(dest1, dest2)
  if not dest1 then
    return dest2
  end
  if not dest2 then
    return dest1
  end

  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_width = vim.api.nvim_win_get_width(0)
  local dist1 = math.abs(dest1[2] - current_pos[2])
    + math.abs(dest1[1] - current_pos[1]) * line_width
  local dist2 = math.abs(dest2[2] - current_pos[2])
    + math.abs(dest2[1] - current_pos[1]) * line_width
  if dist1 <= dist2 then
    return dest1
  else
    return dest2
  end
end

---Check if a node has length larger than 0
---@param node table
---@return boolean
local function node_has_length(node)
  local start_pos, end_pos = node:get_buf_position()
  return start_pos[1] ~= end_pos[1] or start_pos[2] ~= end_pos[2]
end

---Check if range1 contains range2
---If range1 == range2, return true
---@param range1 integer[][] 0-based range
---@param range2 integer[][] 0-based range
---@return boolean
local function range_contains(range1, range2)
  -- stylua: ignore start
  return (
    range2[1][1] > range1[1][1]
    or (range2[1][1] == range1[1][1]
        and range2[1][2] >= range1[1][2])
    )
    and (
      range2[1][1] < range1[2][1]
      or (range2[1][1] == range1[2][1]
          and range2[1][2] <= range1[2][2])
    )
    and (
      range2[2][1] > range1[1][1]
      or (range2[2][1] == range1[1][1]
          and range2[2][2] >= range1[1][2])
    )
    and (
      range2[2][1] < range1[2][1]
      or (range2[2][1] == range1[2][1]
          and range2[2][2] <= range1[2][2])
    )
  -- stylua: ignore end
end

---Check if the cursor position is in the given range
---@param range integer[][] 0-based range
---@param cursor integer[] 1,0-based cursor position
---@return boolean
local function cursor_in_range(range, cursor)
  local cursor0 = { cursor[1] - 1, cursor[2] }
  -- stylua: ignore start
  return (
    cursor0[1] > range[1][1]
    or (cursor0[1] == range[1][1]
        and cursor0[2] >= range[1][2])
    )
    and (
      cursor0[1] < range[2][1]
      or (cursor0[1] == range[2][1]
          and cursor0[2] <= range[2][2])
    )
  -- stylua: ignore end
end

---Find the parent (a previous node that contains the current node) of the node
---@param node table current node
---@return table|nil
local function node_find_parent(node)
  local range_start, range_end = node:get_buf_position()
  local prev = node.parent.snippet and node.parent.snippet.prev.prev
  while prev do
    local range_start_prev, range_end_prev = prev:get_buf_position()
    if
      range_contains(
        { range_start_prev, range_end_prev },
        { range_start, range_end }
      )
    then
      return prev
    end
    prev = prev.parent.snippet and prev.parent.snippet.prev.prev
  end
end

---Check if the cursor is at the end of a node
---@param range table 0-based range
---@param cursor number[] 1,0-based cursor position
---@return boolean
local function cursor_at_end_of_range(range, cursor)
  return range[2][1] + 1 == cursor[1] and range[2][2] == cursor[2]
end

---Jump to the closer destination between a snippet and tabout
---@param snip_dest number[]
---@param tabout_dest number[]?
---@param direction number 1 or -1
---@return boolean true if a jump is performed
local function jump_to_closer(snip_dest, tabout_dest, direction)
  direction = direction or 1
  local dest = choose_closer(snip_dest, tabout_dest)
  if not dest then
    return false
  end
  -- prefer to jump to the snippet if destination is the same
  if dest == snip_dest then
    luasnip.jump(direction)
  else
    vim.api.nvim_win_set_cursor(0, dest)
  end
  return true
end

---Filter out unwanted entries
---@param entry cmp.Entry
---@param _ cmp.Context ignored
---@return boolean
local function entry_filter(entry, _)
  return not vim.tbl_contains({
    'No matches found',
    'Searching...',
    'Workspace loading',
  }, entry.completion_item.label)
end

---Filter out unwanted entries for fuzzy_path source
---@param entry cmp.Entry
---@param context cmp.Context
local function entry_filter_fuzzy_path(entry, context)
  return entry_filter(entry, context)
    -- Don't show fuzzy-path entries in markdown/tex mathzone
    and not (
      vim.g.loaded_vimtex == 1
      and (vim.bo.ft == 'markdown' or vim.bo.ft == 'tex')
      and vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
    )
end

---Options for fuzzy_path source
local fuzzy_path_option = {
  fd_timeout_msec = 100,
  fd_cmd = {
    'fd',
    '--hidden',
    '--full-path',
    '--type',
    'f',
    '--type',
    'd',
    '--type',
    'l',
    '--max-depth',
    '10',
    '--max-results',
    '20',
    '--exclude',
    '.git',
  },
}

cmp.setup({
  formatting = {
    fields = { 'kind', 'abbr' },
    format = function(entry, cmp_item)
      ---@type table<string, string> override icons with `entry.source.name`
      local icon_override = {
        cmdline = icons.Terminal,
        calc = icons.Calculator,
      }
      cmp_item.kind = icon_override[entry.source.name] or icons[cmp_item.kind]
      -- Max and min width of the popup menu
      if #cmp_item.abbr > 40 then
        cmp_item.abbr = string.format(
          '%s…%s',
          string.sub(cmp_item.abbr, 1, 29),
          string.sub(cmp_item.abbr, -10, -1)
        )
      elseif #cmp_item.abbr < vim.go.pumwidth then
        cmp_item.abbr = cmp_item.abbr
          .. string.rep(' ', vim.go.pumwidth - #cmp_item.abbr)
      end
      return cmp_item
    end,
  },
  experimental = { ghost_text = { hl_group = 'Ghost' } },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.mode() == 'i' then
        if luasnip.jumpable(-1) then
          local prev = luasnip.jump_destination(-1)
          local _, snip_dest_end = prev:get_buf_position()
          snip_dest_end[1] = snip_dest_end[1] + 1 -- (1, 0) indexed
          local tabout_dest = tabout.get_jump_pos('<S-Tab>')
          if not jump_to_closer(snip_dest_end, tabout_dest, -1) then
            fallback()
          end
        else
          fallback()
        end
      elseif vim.fn.mode() == 'c' then
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp.complete()
        end
      end
    end, { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.mode() == 'i' then
        if luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.jumpable(1) then
          local buf = vim.api.nvim_get_current_buf()
          local cursor = vim.api.nvim_win_get_cursor(0)
          local current = luasnip.session.current_nodes[buf]
          if node_has_length(current) then
            if
              cursor_at_end_of_range({ current:get_buf_position() }, cursor)
            then
              luasnip.jump(1)
            else
              fallback()
            end
          else -- node has zero length
            local parent = node_find_parent(current)
            local range = parent and { parent:get_buf_position() }
            local tabout_dest = tabout.get_jump_pos('<Tab>')
            if
              tabout_dest
              and range
              and cursor_in_range(range, tabout_dest)
            then
              tabout.do_key('<Tab>')
            else
              luasnip.jump(1)
            end
          end
        else
          fallback()
        end
      elseif vim.fn.mode() == 'c' then
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end
    end, { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(function(fallback)
      if vim.fn.mode() == 'i' then
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          cmp.complete()
        end
      elseif vim.fn.mode() == 'c' then
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end
    end, { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(function(fallback)
      if vim.fn.mode() == 'i' then
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          cmp.complete()
        end
      elseif vim.fn.mode() == 'c' then
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end
    end, { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(
      cmp.mapping.select_next_item({
        behavior = cmp.SelectBehavior.Select,
      }),
      { 'i' }
    ),
    ['<Up>'] = cmp.mapping(
      cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Select,
      }),
      { 'i' }
    ),
    ['<PageDown>'] = cmp.mapping(
      cmp.mapping.select_next_item({
        behavior = cmp.SelectBehavior.Select,
        count = vim.o.pumheight ~= 0 and math.ceil(vim.o.pumheight / 2) or 8,
      }),
      { 'i', 'c' }
    ),
    ['<PageUp>'] = cmp.mapping(
      cmp.mapping.select_prev_item({
        behavior = cmp.SelectBehavior.Select,
        count = vim.o.pumheight ~= 0 and math.ceil(vim.o.pumheight / 2) or 8,
      }),
      { 'i', 'c' }
    ),
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
  },
  sources = {
    { name = 'luasnip', max_item_count = 3 },
    { name = 'nvim_lsp_signature_help' },
    { name = 'copilot' },
    {
      name = 'nvim_lsp',
      max_item_count = 20,
      -- Suppress LSP completion when workspace is not ready yet
      entry_filter = entry_filter,
    },
    { name = 'fuzzy_buffer', max_item_count = 8 },
    { name = 'spell', max_item_count = 8 },
    {
      name = 'fuzzy_path',
      entry_filter = entry_filter_fuzzy_path,
      option = fuzzy_path_option,
    },
    { name = 'calc' },
  },
  sorting = {
    ---@type table[]|function[]
    comparators = {
      require('cmp_fuzzy_path.compare'),
      cmp.config.compare.kind,
      cmp.config.compare.locality,
      cmp.config.compare.recently_used,
      cmp.config.compare.exact,
      cmp.config.compare.score,
    },
  },
  -- cmp floating window config
  window = {
    completion = {
      max_width = 40,
      max_height = 16,
    },
    documentation = {
      max_width = 80,
      max_height = 20,
    },
  },
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  enabled = true,
  sources = { { name = 'fuzzy_buffer' } },
})
cmp.setup.cmdline('?', {
  enabled = true,
  sources = { { name = 'fuzzy_buffer' } },
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  enabled = true,
  sources = {
    {
      name = 'fuzzy_path',
      group_index = 1,
      entry_filter = entry_filter_fuzzy_path,
      option = fuzzy_path_option,
    },
    { name = 'cmdline', group_index = 2 },
  },
})
-- Complete vim.ui.input()
cmp.setup.cmdline('@', {
  enabled = true,
  sources = {
    {
      name = 'fuzzy_path',
      group_index = 1,
      entry_filter = entry_filter_fuzzy_path,
      option = fuzzy_path_option,
    },
    { name = 'cmdline', group_index = 2 },
    { name = 'fuzzy_buffer', group_index = 3 },
  },
})

-- Completion in DAP buffers
cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
  enabled = true,
  sources = {
    { name = 'dap' },
  },
})
