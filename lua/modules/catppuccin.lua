return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- mocha, macchiato, frappe, latte
        compile = {
          enabled = true,
          path = vim.fn.stdpath('cache') .. '/catppuccin',
        },
        custom_highlights = function(colors)
          return {
            -- General
            MatchParen = { fg = colors.yellow, style = { 'bold' } },
            -- FloatBorder = { fg = colors.surface0, bg = 'NONE' }, -- TODO: this seems to not be working
            WinSeparator = { fg = colors.surface2 },
            OverLength = { fg = colors.red, bg = colors.base },

            -- TScontext
            TreesitterContextBottom = {
              sp = colors.surface0, -- INFO: don't know about this
              style = { 'bold', 'italic' },
            },

            -- Neotree
            NeoTreeDirectoryIcon = { fg = colors.overlay1 },

            -- noice
            NoiceCmdlinePopupBorder = { fg = colors.overlay2, bg = 'NONE' },
            NoiceCmdlinePopupTitle = { fg = colors.subtext0 },
            -- navic
            NavicText = { fg = colors.subtext1 },
            NavicSeparator = { fg = colors.overlay0 },
            -- cmp
            -- CmpItemMenu = { fg = colors.mauve, bg = 'NONE' },
            -- CmpBorder = { fg = colors.surface1, bg = 'NONE' },
          }
        end,
        term_colors = true,
        styles = {
          comments = { 'italic' },
          strings = { 'italic' },
        },
        integrations = {
          gitsigns = true,
          notify = true,
          noice = true,
          neogit = true,
          dashboard = true,
          telescope = { enabled = true, style = 'nvchad' },
          which_key = true,
          treesitter = true,
          fidget = true,
          cmp = true,
          flash = true,
          treesitter_context = true,
          mason = true,
          harpoon = true,
          lsp_saga = true,
          navic = {
            enabled = true,
            custom_bg = 'NONE',
          },
          dap = {
            enabled = true,
            enable_ui = true,
          },
          native_lsp = {
            enabled = true,
            inlay_hints = {
              background = false,
            },
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'undercurl' },
              hints = { 'undercurl' },
              warnings = { 'undercurl' },
              information = { 'underline' },
            },
          },
        },
      })

      vim.cmd([[colorscheme catppuccin]])
    end,
    build = ':CatppuccinCompile',
    priority = 1000,
    enabled = true,
  },
}
