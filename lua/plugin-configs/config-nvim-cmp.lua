vim.cmd [[ :packadd lspkind-nvim ]]     -- Ensure that lspkind icon is loaded

local cmp = require "cmp"
local lspkind = require("lspkind")

cmp.setup({
    formatting = {
        format = lspkind.cmp_format {
            with_text = false,
            maxwidth = 50,
            menu = {
                buffer = '[BUFFER]',
                nvim_lsp = '[LSP]',
                path = '[PATH]',
                vsnip = '[VSNIP]',
                calc = '[CALC]',
                spell = '[SPELL]',
                emoji = '[EMOJI]'
            }
        }
    },
    experimental = {native_menu = true, ghost_text = true},
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<M-;>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        },
    },
    sources = {
        {name = "nvim_lsp"}, {name = "buffer", keyword_length = 5},
        {name = "vsnip"}, {name = "calc"}, {name = "emoji"}, {name = "spell"},
        {name = "path"}
    }
})

-- Use buffer source for `/`.
cmp.setup.cmdline("/", {sources = {{name = "buffer"}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}})
})
