local M = {}

M['nvim-cmp'] = function()
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local icons = require('utils.static').icons

  cmp.setup({
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.menu = string.format('[%s]', string.upper(entry.source.name))

        -- Use a terminal icon for completions from cmp-cmdline
        if entry.source.name == 'cmdline' then
          vim_item.kind = icons.Terminal
        elseif entry.source.name == 'calc' then
          vim_item.kind = icons.Calculator
        else
          vim_item.kind = icons[vim_item.kind]
        end
        -- Max word length visible
        if #(vim_item.abbr) > 40 then
        vim_item.abbr = string.format('%s…%s',
          string.sub(vim_item.abbr, 1, 23), string.sub(vim_item.abbr, -16, -1))
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
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if vim.fn.mode() == 'i' then
          if luasnip.in_snippet() and luasnip.jumpable(-1) then
            luasnip.jump(-1)
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
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
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
      ['<C-b>'] = cmp.mapping.scroll_docs(-8),
      ['<C-f>'] = cmp.mapping.scroll_docs(8),
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-y>'] = cmp.mapping.scroll_docs(-1),
      ['<C-e>'] = cmp.mapping.scroll_docs(1),
      ['<C-l>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false
      }
    },
    sources = {
      { name = 'luasnip', max_item_count = 3 },
      { name = 'nvim_lsp_signature_help' },
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
      }
    },
    -- cmp floating window config
    window = {
      completion = {
        border = 'single',
        max_width = 40,
        max_height = 16,
      },
      documentation = {
        border = 'single',
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
  -- Use cmdline & path source for ':'.
  cmp.setup.cmdline(':', {
    enabled = true,
    sources = {
      { name = 'path', group_index = 1 },
      { name = 'cmdline', group_index = 2 },
    }
  })
end

M['copilot-cmp'] = function()
  require('copilot_cmp').setup()
end

M['copilot.lua'] = function()
  vim.defer_fn(function()
    if vim.g.loaded_coplilot then
      return
    end
    vim.g.loaded_coplilot = true
    require('copilot').setup({
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<C-j>',
        },
      },
    })
  end, 100)
end

M['LuaSnip'] = function()
  local fn = vim.fn
  local ls = require('luasnip')
  local ls_types = require('luasnip.util.types')
  local icons = require('utils.static').icons

  local function lazy_load_snippets()
    local snippets_path = vim.split(fn.globpath(fn.stdpath('config')
                        .. '/lua/modules/completion/snippets/', '*'), '\n')
    for _, path in ipairs(snippets_path) do
      local ft = fn.fnamemodify(path, ':t:r')
      vim.api.nvim_create_autocmd('FileType', {
        pattern = ft,
        once = true,
        callback = function()
          local snip_groups = require('modules/completion/snippets.' .. ft)
          for _, snip_group in pairs(snip_groups) do
            ls.add_snippets(ft, snip_group.snip or snip_group, snip_group.opts or {})
          end
        end
      })
    end
  end

  local function set_keymap()
    vim.keymap.set('s', '<Tab>', function() ls.jump(1) end, { noremap = false })
    vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end, { noremap = false })
  end

  ls.setup({
    history = true,
    region_check_events = 'CursorMoved',
    delete_check_events = 'TextChangedI',
    updateevents = 'TextChanged,TextChangedI,InsertLeave',
    enable_autosnippets = true,
    store_selection_keys = '<Tab>',
    ext_opts = {
      [ls_types.choiceNode] = {
        active = {
          virt_text = { { icons.Enum, 'Tea' } },
        },
      },
      [ls_types.insertNode] = {
        active = {
          virt_text = { { icons.Snippet, 'Tea' } },
        },
      },
    },
  })

  lazy_load_snippets()
  set_keymap()
end

return M
