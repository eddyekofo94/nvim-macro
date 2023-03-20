local cmp = require('cmp')
local luasnip = require('luasnip')
local tabout = require('plugin.tabout')
local icons = require('utils.static').icons

local function choose_closest(dest1, dest2)
  if not dest1 then return dest2 end
  if not dest2 then return dest1 end

  local current_pos = vim.api.nvim_win_get_cursor(0)
  local line_width = vim.api.nvim_win_get_width(0)
  local dist1 = math.abs(dest1[2] - current_pos[2]) +
      math.abs(dest1[1] - current_pos[1]) * line_width
  local dist2 = math.abs(dest2[2] - current_pos[2]) +
      math.abs(dest2[1] - current_pos[1]) * line_width
  if dist1 <= dist2 then
    return dest1
  else
    return dest2
  end
end

local function jump_to_closest(snip_dest, tabout_dest, direction)
  direction = direction or 1
  local dest = choose_closest(snip_dest, tabout_dest)
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
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.menu = string.format('[%s]', entry.source.name:upper())
      if entry.source.name == 'nvim_lsp_signature_help' then
        vim_item.menu = '[LSP_SIG]'
      end

      -- Use a terminal icon for completions from cmp-cmdline
      if entry.source.name == 'cmdline' then
        vim_item.kind = icons.Terminal
      elseif entry.source.name == 'calc' then
        vim_item.kind = icons.Calculator
      else
        vim_item.kind = icons[vim_item.kind]
      end
      -- Max word length visible
      if #(vim_item.abbr) > 30 then
        vim_item.abbr = string.format('%s…%s',
          string.sub(vim_item.abbr, 1, 19),
          string.sub(vim_item.abbr, -10, -1))
      end

      return vim_item
    end
  },
  experimental = { ghost_text = { hl_group = 'Ghost' } },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = {
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.mode() == 'i' then
        if luasnip.in_snippet() then
          local next_node = luasnip.jump_destination(-1)
          local _, snip_dest_end = next_node:get_buf_position()
          snip_dest_end[1] = snip_dest_end[1] + 1 -- (1, 0) indexed
          local tabout_dest = tabout.get_jump_pos('<S-Tab>')
          if not jump_to_closest(snip_dest_end, tabout_dest, -1) then
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
            local current = luasnip.session.current_nodes[buf]
            local _, current_end = current:get_buf_position()
            current_end[1] = current_end[1] + 1 -- (1, 0) indexed
            local cursor = vim.api.nvim_win_get_cursor(0)
            if current_end[1] == cursor[1] and current_end[2] == cursor[2] then
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
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-c>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
      else
        fallback()
      end
    end, { 'i' }),
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    }
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
      end
    },
    { name = 'buffer', max_item_count = 8 },
    { name = 'spell', max_item_count = 8 },
    { name = 'path' },
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
    }
  },
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
  enabled = true,
  sources = { { name = 'buffer' } }
})
cmp.setup.cmdline('?', {
  enabled = true,
  sources = { { name = 'buffer' } }
})
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  enabled = true,
  sources = {
    { name = 'path', group_index = 1 },
    { name = 'cmdline', group_index = 2 },
  }
})
