local M = {}

M.cmp = require 'cmp'
M.luasnip = require 'luasnip'
M.context = require 'cmp.config.context'

local icons = require('utils.static').icons

M.opts = {
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.menu = '[' .. string.upper(entry.source.name) .. ']'
      -- Do not show kind icon for emoji
      if entry.source.name == 'emoji' then
        vim_item.kind = ''
        -- Use a terminal icon for completions from cmp-cmdline
      elseif entry.source.name == 'cmdline' then
        vim_item.kind = icons.Terminal .. ' '
      elseif entry.source.name == 'calc' then
        vim_item.kind = icons.Calculator .. ' '
      else
        vim_item.kind = string.format('%s ', icons[vim_item.kind])
      end
      -- Max word length visible
      if #(vim_item.abbr) > 40 then
        vim_item.abbr = string.sub(vim_item.abbr, 1, 23)
            .. '…'
            .. string.sub(vim_item.abbr, -16, -1)
      end

      return vim_item
    end
  },
  experimental = { ghost_text = true },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = {
    ['<S-Tab>'] = M.cmp.mapping(function(fallback)
      if M.luasnip.jumpable(-1) then
        M.luasnip.jump(-1)
      elseif M.cmp.visible() then
        M.cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<Tab>'] = M.cmp.mapping(function(fallback)
      if M.luasnip.expand_or_jumpable() then
        M.luasnip.expand_or_jump()
      elseif M.cmp.visible() then
        M.cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<C-p>'] = M.cmp.mapping(function()
      if M.cmp.visible() then
        M.cmp.select_prev_item()
      else
        M.cmp.complete()
      end
    end),
    ['<C-n>'] = M.cmp.mapping(function()
      if M.cmp.visible() then
        M.cmp.select_next_item()
      else
        M.cmp.complete()
      end
    end),
    ['<C-b>'] = M.cmp.mapping.scroll_docs(-8),
    ['<C-f>'] = M.cmp.mapping.scroll_docs(8),
    ['<C-u>'] = M.cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = M.cmp.mapping.scroll_docs(4),
    ['<C-y>'] = M.cmp.mapping.scroll_docs(-1),
    ['<C-e>'] = M.cmp.mapping.scroll_docs(1),
    ['<CR>'] = M.cmp.mapping.confirm {
      behavior = M.cmp.ConfirmBehavior.Replace,
      select = false
    }
  },
  sources = {
    {
      name = 'nvim_lsp',
      -- Suppress LSP completion when workspace is not ready yet
      entry_filter = function(entry, ctx)
        return not entry.completion_item.label:match('Workspace loading')
      end
    },
    { name = 'copilot' },
    { name = 'path' },
    { name = 'buffer', max_item_count = 5, group_index = 1 },
    { name = 'spell', max_item_count = 5, group_index = 2 },
    { name = 'luasnip' }, { name = 'calc' }, { name = 'emoji' }
  },
  sorting = {
    comparators = {
      M.cmp.config.compare.kind,
      M.cmp.config.compare.score,
      M.cmp.config.compare.locality,
      M.cmp.config.compare.recently_used,
    }
  },
  -- cmp floating window config
  window = {
    completion = { border = 'single' },
    documentation = { border = 'single' }
  }
}
M.cmp.setup(M.opts)

M.opts_cmdline = {}
M.opts_cmdline['/'] = { enabled = true, sources = { { name = 'buffer' } } }
M.opts_cmdline[':'] = {
  enabled = true,
  sources = {
    { name = 'path' },
    { name = 'cmdline' },
  }
}
-- Use buffer source for `/`.
M.cmp.setup.cmdline('/', M.opts_cmdline['/'])
-- Use cmdline & path source for ':'.
M.cmp.setup.cmdline(':', M.opts_cmdline[':'])

return M
