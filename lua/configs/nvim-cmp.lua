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

---Check if a node is valid (i.e. has a range)
---@param node table
---@return boolean
local function node_is_valid(node)
  local start_pos, end_pos = node:get_buf_position()
  return start_pos[1] ~= end_pos[1] or start_pos[2] ~= end_pos[2]
end

---Check if the cursor is at the end of a node
---@param node table
---@param cursor number[]
---@return boolean
local function cursor_at_end_of_node(node, cursor)
  local _, end_pos = node:get_buf_position()
  return end_pos[1] + 1 == cursor[1] and end_pos[2] == cursor[2]
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

cmp.setup({
  formatting = {
    fields = { 'kind', 'abbr' },
    format = function(entry, vim_item)
      -- Use a terminal icon for completions from cmp-cmdline
      if entry.source.name == 'cmdline' then
        vim_item.kind = icons.Terminal
      elseif entry.source.name == 'calc' then
        vim_item.kind = icons.Calculator
      else
        vim_item.kind = icons[vim_item.kind]
      end
      -- Max and min width of the popup menu
      if #vim_item.abbr > 40 then
        vim_item.abbr = string.format(
          '%s…%s',
          string.sub(vim_item.abbr, 1, 29),
          string.sub(vim_item.abbr, -10, -1)
        )
      elseif #vim_item.abbr < vim.go.pumwidth then
        vim_item.abbr = vim_item.abbr
          .. string.rep(' ', vim.go.pumwidth - #vim_item.abbr)
      end

      return vim_item
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
          if luasnip.choice_active() then
            luasnip.jump(1)
          else
            local buf = vim.api.nvim_get_current_buf()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local current = luasnip.session.current_nodes[buf]
            while current and not node_is_valid(current) do
              luasnip.unlink_current()
              current = luasnip.session.current_nodes[buf]
            end
            if current and cursor_at_end_of_node(current, cursor) then
              luasnip.jump(1)
            else
              fallback()
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
      entry_filter = function(entry, _)
        return not entry.completion_item.label:match('Workspace loading')
      end,
    },
    { name = 'fuzzy_buffer', max_item_count = 8 },
    { name = 'spell', max_item_count = 8 },
    {
      name = 'fuzzy_path',
      entry_filter = function(entry, _)
        return not entry.completion_item.label:match('No matches found')
      end,
    },
    { name = 'calc' },
  },
  sorting = {
    comparators = {
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
      max_height = 16,
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
      entry_filter = function(entry, _)
        return not entry.completion_item.label:match('No matches found')
      end,
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
      entry_filter = function(entry, _)
        return not entry.completion_item.label:match('No matches found')
      end,
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
