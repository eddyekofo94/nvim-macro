vim.cmd [[ :packadd lspkind-nvim ]]     -- Ensure that lspkind icon is loaded
vim.cmd [[ :packadd cmp-under-comparator ]]

local cmp = require "cmp"
local lspkind = require("lspkind")

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

lspkind.init({
    symbol_map = {
        Field = "",
        Property = "",
        Text = "",
        Enum = "",
        EnumMember = "",
        TypeParameter = "𝙏",
        Class = ""
    }
})

cmp.setup({
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format {
            with_text = false,
            maxwidth = 50,
            before = function (entry, vim_item)
                vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
                if entry.source.name == 'emoji' then
                    vim_item.kind = ""    -- Do not show kind icon for emoji
                else
                    vim_item.abbr = " " .. vim_item.word
                end
                return vim_item
            end
        }
    },
    experimental = {native_menu = false, ghost_text = true},
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
                fallback()  -- The fallback function sends a already mapped key,
            end             -- in this case, it's probably `<Tab>`.
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-8),
        ["<C-f>"] = cmp.mapping.scroll_docs(8),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.scroll_docs(-1),
        ["<C-y>"] = cmp.mapping.scroll_docs(1),
        ["<M-;>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.close()
            else
                cmp.complete()
            end
        end, { "i", "s" } ),
        ["<esc>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        },
    },
    sources = {
        {name = "nvim_lsp"}, {name = "path"},
        {name = "spell", max_item_count = 5},
        {name = "buffer", max_item_count = 10},
        {name = "vsnip"}, {name = "calc"}, {name = "emoji"}
    },
    sorting = {
        comparators = {
            cmp.config.compare.offset, cmp.config.compare.exact,
            cmp.config.compare.score, require 'cmp-under-comparator'.under,
            cmp.config.compare.kind, cmp.config.compare.sort_text,
            cmp.config.compare.length, cmp.config.compare.order
        }
    },
    -- cmp floating window border
    documentation = {
      border = 'single',
      winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder'
    }
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})
})
