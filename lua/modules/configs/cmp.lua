local cmp = require "cmp"
local types = require "cmp.types"
local compare = require "cmp.config.compare"
local luasnip = require "luasnip"
local lspkind = require "lspkind"
local visible_buffers = require("utils.buffer").visible_buffers
local utils_cmp = require "utils.cmp"
local icons = require("utils.static").icons

local entry_filter_fuzzy_path, fuzzy_path_option, limit_lsp_types, has_words_before, check_backspace =
  utils_cmp.fuzzy_path_option,
  utils_cmp.entry_filter_fuzzy_path,
  utils_cmp.limit_lsp_types,
  utils_cmp.has_words_before,
  utils_cmp.check_backspace

local fuzzy_path_ok, fuzzy_path_comparator = pcall(require, "cmp_fuzzy_path.compare")

if not fuzzy_path_ok then
  fuzzy_path_comparator = function() end
end

local icon_folder = icons.Folder
local icon_file = icons.File
local compltype_path = {
  dir = true,
  file = true,
  file_in_path = true,
  runtime = true,
}

local border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

lspkind.init {
  preset = "codicons",
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---@type table<integer, integer>
local modified_priority = {
  [types.lsp.CompletionItemKind.Variable] = 1,
  [types.lsp.CompletionItemKind.Constant] = 1,
  [types.lsp.CompletionItemKind.Keyword] = 1, -- top
  [types.lsp.CompletionItemKind.Snippet] = 2,
  [types.lsp.CompletionItemKind.Function] = types.lsp.CompletionItemKind.Method,
  [types.lsp.CompletionItemKind.Text] = 100, -- bottom
}

---@param kind integer: kind of completion entry
local function modified_kind(kind)
  return modified_priority[kind] or kind
end

cmp.setup {
  enabled = function()
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    if buftype == "prompt" or buftype == "acwrite" or vim.b.bigfile then
      return false
    end

    -- disable completion in comments
    local context = require "cmp.config.context"
    -- keep command mode completion enabled when cursor is in a comment.
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
    end
  end,
  completion = {
    completeopt = "menu,menuone,noinsert",
    autocomplete = { types.cmp.TriggerEvent.TextChanged },
    keyword_length = 1,
  },
  -- explanations: https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt#L425
  performance = {
    async_budget = 64,
    max_view_entries = 10,
    fetching_timeout = 250,
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
      -- vim.snippet.expand(args.body)
    end,
  },
  matching = {
    disallow_fuzzy_matching = false,
    disallow_fullfuzzy_matching = false,
    disallow_partial_fuzzy_matching = true,
    disallow_partial_matching = false,
    disallow_prefix_unmatching = true,
  },
  duplicates = {
    nvim_lsp = 0,
    luasnip = 1,
    buffer = 1,
    rg = 0,
    path = 1,
  },
  duplicates_default = 0,
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  mapping = {
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<c-q>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ["<C-Space>"] = cmp.mapping {
      i = cmp.mapping.complete(),
      c = function(_)
        if cmp.visible() then
          if not cmp.confirm { select = true } then
            return
          end
        else
          cmp.complete()
        end
      end,
    },
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- ["<C-l>"] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     return cmp.complete_common_string()
    --   end
    --   fallback()
    -- end),
    ["<CR>"] = cmp.mapping.confirm {
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }
        else
          fallback()
        end
      end,
      c = function(fallback)
        if cmp.visible() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
        else
          fallback()
        end
      end,
      s = function(fallback)
        if cmp.visible() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true }
        else
          fallback()
        end
      end,
      -- s = cmp.mapping { select = true },
    },
    ["<C-j>"] = cmp.mapping {
      s = function()
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Replace }
        else
          vim.api.nvim_feedkeys(t "<Down>", "n", true)
        end
      end,
      c = function()
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Replace }
        else
          vim.api.nvim_feedkeys(t "<Down>", "n", true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif check_backspace() then
          fallback()
        else
          fallback()
        end
      end,
    },
    ["<C-k>"] = cmp.mapping {
      c = function()
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Replace }
        else
          vim.api.nvim_feedkeys(t "<Up>", "n", true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      elseif cmp.visible() and has_words_before() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-c>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() then
          cmp.abort()
        else
          fallback()
        end
      end,
      c = function(fallback)
        if cmp.visible() then
          cmp.close()
        else
          fallback()
        end
      end,
    },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      { "i", "c" }
    ),
  },
  sources = {
    { name = "async_path", max_item_count = 20 },
    {
      name = "nvim_lsp",
      priority_weight = 85,
      max_item_count = 50,
      -- keyword_length = 1,
      -- Limits LSP results to specific types based on line context (Fields, Methods, Variables)
      entry_filter = limit_lsp_types, --  INFO: 2024-05-14 - Maybe remove this
    },
    { name = "nvim_lsp_signature_help" },
    {
      name = "path",
    },
    {
      name = "fuzzy_path",
      option = { fd_timeout_msec = 1500 },
    },
    {
      name = "luasnip",
      keyword_length = 2,
      max_item_count = 3,
      dup = 0,
      option = {
        use_show_condition = true,
        show_autosnippets = true,
      },
      entry_filter = function()
        local context = require "cmp.config.context"
        return not context.in_treesitter_capture "string" and not context.in_syntax_group "String"
      end,
    },

    { name = "nvim_lua" },
    {
      name = "treesitter",
      keyword_length = 4,
      max_item_count = 5,
    },
    { name = "neorg" },
    {
      name = "buffer",
      max_item_count = 3,
      keyword_length = 3,
      dup = 0,
      option = {
        get_bufnrs = visible_buffers, -- Suggest words from all visible buffers
      },
    },
    {
      name = "rg",
      priority_weight = 60,
      max_item_count = 10,
      keyword_length = 4,
      dup = 0,
      option = {
        additional_arguments = "--smart-case",
      },
    },
    { name = "calc" },
  },
  view = {
    entries = { follow_cursor = true, name = "custom", selection_order = "near_cursor" },
  },
  window = {
    completion = cmp.config.window.bordered {
      border = border,
      winhighlight = "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
      col_offset = -3,
      side_padding = 0,
      scrolloff = vim.go.scrolloff,
    },
    documentation = cmp.config.window.bordered {},
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.locality,
      function(entry1, entry2) -- score by lsp, if available
        local t1 = entry1.completion_item.sortText
        local t2 = entry2.completion_item.sortText
        if t1 ~= nil and t2 ~= nil and t1 ~= t2 then
          return t1 < t2
        end
      end,
      compare.offset,
      compare.recently_used,
      compare.exact,
      function(entry1, entry2) -- sort by compare kind (Variable, Function etc)
        local kind1 = modified_kind(entry1:get_kind())
        local kind2 = modified_kind(entry2:get_kind())
        if kind1 ~= kind2 then
          return kind1 - kind2 < 0
        end
      end,
      function(entry1, entry2) -- sort by length ignoring "=~"
        local len1 = string.len(string.gsub(entry1.completion_item.label, "[=~()]", ""))
        local len2 = string.len(string.gsub(entry2.completion_item.label, "[=~()]", ""))
        if len1 ~= len2 then
          return len1 - len2 < 0
        end
      end,
      compare.scopes,
      compare.sort_text,
      compare.order,
      fuzzy_path_comparator,
    },
  },
  experimental = {
    native_menu = false,
    ghost_text = false,
    git = {
      async = true,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = lspkind.cmp_format { mode = "symbol_text", maxwidth = 50 }(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. (strings[1] or "") .. " "
      kind.menu = "    [" .. (strings[2] or "") .. "]"

      local compltype = vim.fn.getcmdcompltype()
      local complpath = compltype_path[compltype]

      if vim_item.kind == "File" or vim_item.kind == "Folder" or complpath then
        if string.sub(vim_item.word, #vim_item.word) == "/" then -- Directories
          vim_item.kind = icon_folder
          vim_item.kind_hl_group = "CmpItemKindFolder"
        else -- Files
          local icon = icon_file
          local icon_hl = "CmpItemKindFile"
          local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
          if devicons_ok then
            icon, icon_hl = devicons.get_icon(
              vim.fs.basename(vim_item.word),
              vim.fn.fnamemodify(vim_item.word, ":e"),
              { default = true }
            )
            icon = icon and icon .. " "
          end
          vim_item.kind = icon or icon_file
          vim_item.kind_hl_group = icon_hl or "CmpItemKindFile"
        end
        -- else
        --   vim_item.kind = entry.source.name == "cmdline" and icon_dot or icons[vim_item.kind] or ""
      end

      ---@param field string
      ---@param min_width integer
      ---@param max_width integer
      ---@return nil
      local function clamp(field, min_width, max_width)
        if not vim_item[field] or not type(vim_item) == "string" then
          return
        end
        -- In case that min_width > max_width
        if min_width > max_width then
          min_width, max_width = max_width, min_width
        end
        local field_str = vim_item[field]
        local field_width = vim.fn.strdisplaywidth(field_str)
        if field_width > max_width then
          local former_width = math.floor(max_width * 0.6)
          local latter_width = math.max(0, max_width - former_width - 1)
          vim_item[field] = string.format("%s…%s", field_str:sub(1, former_width), field_str:sub(-latter_width))
        elseif field_width < min_width then
          vim_item[field] = string.format("%-" .. min_width .. "s", field_str)
        end
      end
      clamp("abbr", vim.go.pw, math.max(60, math.ceil(vim.o.columns * 0.4)))
      clamp("menu", 0, math.max(16, math.ceil(vim.o.columns * 0.2)))
      -- append source name to menu
      if entry.completion_item.detail ~= nil and entry.completion_item.detail ~= "" then
        kind.menu = kind.menu .. "    (" .. entry.completion_item.detail .. ")"
      end

      return vim_item
    end,
  },
}

cmp.setup.filetype({ "NeogitCommitMessage", "TelescopePrompt" }, {
  sources = {},
})

-- Set configuration for specific filetype.
-- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }),
})

cmp.setup.filetype({ "oil" }, {
  enabled = true,
  sources = {
    {
      name = "rg",
      priority_weight = 60,
      max_item_count = 10,
      keyword_length = 5,
      option = {
        additional_arguments = "--smart-case",
      },
    },
    {
      name = "spell",
      keyword_length = 3,
      priority = 5,
      keyword_pattern = [[\w\+]],
    },
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = "buffer" },
  }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  enabled = true,
  sources = cmp.config.sources {
    {
      name = "cmdline",
      option = {
        ignore_cmds = {},
      },
      max_item_count = 30,
      group_index = 2,
    },
    { name = "cmdline_history", max_item_count = 10 },
    {
      name = "fuzzy_path",
      group_index = 1,
      option = { fd_timeout_msec = 1500 },
    },
    { name = "path", max_item_count = 20 },
  },
})

-- Complete vim.ui.input()
cmp.setup.cmdline("@", {
  enabled = true,
  sources = {
    {
      name = "fuzzy_path",
      group_index = 1,
      -- entry_filter = entry_filter_fuzzy_path,
      -- option = fuzzy_path_option,
    },
    {
      name = "cmdline",
      group_index = 2,
      option = {
        ignore_cmds = {},
      },
    },
    {
      name = "buffer",
      group_index = 3,
      option = {
        get_bufnrs = visible_buffers,
      },
    },
  },
})

-- cmp does not work with cmdline with type other than `:`, '/', and '?', e.g.
-- it does not respect the completion option of `input()`/`vim.ui.input()`, see
-- https://github.com/hrsh7th/nvim-cmp/issues/1690
-- https://github.com/hrsh7th/nvim-cmp/discussions/1073
cmp.setup.cmdline("@", { enabled = false })
cmp.setup.cmdline(">", { enabled = false })
cmp.setup.cmdline("-", { enabled = false })
cmp.setup.cmdline("=", { enabled = false })

-- Completion in DAP buffers
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  enabled = true,
  sources = {
    { name = "dap" },
  },
})
