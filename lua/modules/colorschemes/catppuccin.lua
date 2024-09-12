return {
  "catppuccin/nvim",
  enabled = true,
  name = "catppuccin",
  config = function()
    require("catppuccin").setup {
      flavour = "mocha", -- mocha, macchiato, frappe, latte
      compile = {
        enabled = true,
        path = vim.fn.stdpath "cache" .. "/catppuccin",
      },
      color_overrides = {
        -- mocha = {
        --   rosewater = "#efc9c2",
        --   flamingo = "#ebb2b2",
        --   pink = "#f2a7de",
        --   mauve = "#b889f4",
        --   red = "#ea7183",
        --   maroon = "#ea838c",
        --   peach = "#f39967",
        --   yellow = "#eaca89",
        --   green = "#96d382",
        --   teal = "#78cec1",
        --   sky = "#91d7e3",
        --   sapphire = "#68bae0",
        --   blue = "#739df2",
        --   lavender = "#a0a8f6",
        --   text = "#b5c1f1",
        --   subtext1 = "#a6b0d8",
        --   subtext0 = "#959ec2",
        --   overlay2 = "#848cad",
        --   overlay1 = "#717997",
        --   overlay0 = "#63677f",
        --   surface2 = "#505469",
        --   surface1 = "#3e4255",
        --   surface0 = "#2c2f40",
        --   base = "#1a1c2a",
        --   mantle = "#141620",
        --   crust = "#0e0f16",
        -- },
      },
      custom_highlights = function(colors)
        return {

          -- General
          MatchParen = { fg = colors.yellow, style = { "bold" } },
          FloatBorder = { fg = colors.surface0, bg = "NONE" }, -- TODO: this seems to not be working
          WinSeparator = { fg = colors.surface2 },
          OverLength = { fg = colors.red, bg = colors.base },
          HighlightedyankRegion = {
            reverse = true,
          },

          -- TScontext
          TreesitterContextBottom = {
            sp = colors.surface0, -- INFO: don't know about this
            style = { "bold", "italic" },
          },

          -- noice
          NoiceCmdlinePopupBorder = { fg = colors.overlay2, bg = "NONE" },
          NoiceCmdlinePopupTitle = { fg = colors.subtext0 },
          -- navic
          NavicText = { fg = colors.subtext1 },
          NavicSeparator = { fg = colors.overlay0 },
          -- cmp
          CmpSel = { fg = colors.base, bg = colors.green },
          CmpItemMenu = { fg = colors.mauve, bg = "NONE" },
          -- CmpBorder = { fg = colors.surface1, bg = "NONE" },
          CmpItemKindSnippet = { fg = colors.base, bg = colors.mauve },
          CmpItemKindKeyword = { fg = colors.base, bg = colors.red },
          CmpItemKindText = { fg = colors.base, bg = colors.teal },
          CmpItemKindMethod = { fg = colors.base, bg = colors.blue },
          CmpItemKindConstructor = { fg = colors.base, bg = colors.blue },
          CmpItemKindFunction = { fg = colors.base, bg = colors.blue },
          CmpItemKindFolder = { fg = colors.base, bg = colors.blue },
          CmpItemKindModule = { fg = colors.base, bg = colors.blue },
          CmpItemKindConstant = { fg = colors.base, bg = colors.peach },
          CmpItemKindField = { fg = colors.base, bg = colors.green },
          CmpItemKindProperty = { fg = colors.base, bg = colors.green },
          CmpItemKindEnum = { fg = colors.base, bg = colors.green },
          CmpItemKindUnit = { fg = colors.base, bg = colors.green },
          CmpItemKindClass = { fg = colors.base, bg = colors.yellow },
          CmpItemKindVariable = { fg = colors.base, bg = colors.flamingo },
          CmpItemKindFile = { fg = colors.base, bg = colors.blue },
          CmpItemKindInterface = { fg = colors.base, bg = colors.yellow },
          CmpItemKindColor = { fg = colors.base, bg = colors.red },
          CmpItemKindReference = { fg = colors.base, bg = colors.red },
          CmpItemKindEnumMember = { fg = colors.base, bg = colors.red },
          CmpItemKindStruct = { fg = colors.base, bg = colors.blue },
          CmpItemKindValue = { fg = colors.base, bg = colors.peach },
          CmpItemKindEvent = { fg = colors.base, bg = colors.blue },
          CmpItemKindOperator = { fg = colors.base, bg = colors.blue },
          CmpItemKindTypeParameter = { fg = colors.base, bg = colors.blue },
          CmpItemKindCopilot = { fg = colors.base, bg = colors.teal },

          NeotestPassed = { fg = colors.green },
          NeotestFailed = { fg = colors.red },
          NeotestRunning = { fg = colors.yellow },
          NeotestSkipped = { fg = colors.blue },
          NeotestFile = { fg = colors.peach },
          NeotestNamespace = { fg = colors.peach },
          NeotestDir = { fg = colors.peach },
          NeotestFocused = { fg = colors.mauve, bold = true, underline = true },
          NeotestAdapterName = { fg = colors.red },
          NeotestIndent = { fg = colors.yellow },
          NeotestExpandMarker = { fg = colors.yellow },
          NeotestWinSelect = { fg = colors.yellow, bold = true },
          NeotestTest = { fg = colors.subtext2 },
        }
      end,
      term_colors = true,
      styles = {
        comments = { "italic" },
        strings = { "italic" },
      },
      integrations = {
        gitsigns = true,
        notify = true,
        noice = true,
        neogit = true,
        dashboard = true,
        diffview = true,
        ufo = true,
        telescope = { enabled = true, style = "nvchad" },
        which_key = true,
        colorful_winsep = true,
        treesitter = true,
        fidget = true,
        cmp = true,
        flash = true,
        treesitter_context = true,
        mason = true,
        harpoon = true,
        lsp_trouble = true,
        navic = {
          enabled = true,
          custom_bg = "NONE",
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
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          mini = {
            enabled = true,
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    }

    vim.cmd [[colorscheme catppuccin]]
    vim.cmd.highlight "DiagnosticUnderlineError gui=undercurl" -- use undercurl for error, if supported by terminal
  end,
  build = ":CatppuccinCompile",
  priority = 1000,
}
