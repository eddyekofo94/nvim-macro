local cmp = require 'cmp'

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local sym_map = {
  Field = '',
  Property = '',
  Text = '',
  Enum = '',
  EnumMember = '',
  TypeParameter = '',
  Class = '',
  Method = '',
  Function = '',
  Constructor = '',
  Interface = '',
  Module = '',
  Unit = '塞',
  Value = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  Variable = '',
  File = '',
  Reference = '',
  Folder = '',
  Constant = '',
  Struct = 'פּ',
  Event = '',
  Operator = '',
}

cmp.setup({
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function (entry, vim_item)
      vim_item.menu = '[' .. string.upper(entry.source.name) .. ']'
      -- Do not show kind icon for emoji
      if entry.source.name == 'emoji' then
        vim_item.kind = ''
      -- Use a terminal icon for completions from cmp-cmdline
      elseif entry.source.name == 'cmdline' then
        vim_item.kind = ' '
      elseif entry.source.name == 'calc' then
        vim_item.kind = ' '
      else
        vim_item.kind = string.format('%s ', sym_map[vim_item.kind])
      end
      -- Max word length visible
      if #(vim_item.abbr) > 30 then
        vim_item.abbr = string.sub(vim_item.abbr, 1, 18)
                        .. '…'
                        .. string.sub(vim_item.abbr, -11, -1)
      end

      return vim_item
    end
  },
  experimental = {native_menu = false, ghost_text = true},
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end
  },
  mapping = {
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()  -- The fallback function sends a already mapped key,
      end       -- in this case, it's probably `<Tab>`.
    end, { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-8),
    ['<C-f>'] = cmp.mapping.scroll_docs(8),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.scroll_docs(-1),
    ['<C-e>'] = cmp.mapping.scroll_docs(1),
    ['<M-;>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end, { 'i', 'c' } ),
    ['<esc>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    }
  },
  sources = {
    {name = 'nvim_lsp'}, {name = 'path'},
    {name = 'spell', max_item_count = 5},
    {name = 'buffer', max_item_count = 10},
    {name = 'vsnip'}, {name = 'calc'}, {name = 'emoji'}
  },
  sorting = {
    comparators = {
      cmp.config.compare.score,
      cmp.config.compare.offset, cmp.config.compare.exact,
      cmp.config.compare.kind, cmp.config.compare.sort_text,
      cmp.config.compare.length, cmp.config.compare.order
    }
  },
  -- cmp floating window config
  window = {
    completion = { border = 'single' },
    documentation = { border = 'single' }
  }
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
  sources = {
    {name = 'path'},
    -- Do not show completion for words starting with '!' (huge lag, why?)
    {name = 'cmdline', keyword_pattern = [[\!\@<!\w*]]},
  }
})
