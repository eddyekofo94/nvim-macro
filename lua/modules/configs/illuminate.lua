local config = function()
  local illuminate = require "illuminate"
  illuminate.configure {
    providers = {
      "lsp",
      "treesitter",
      "regex",
    },
    delay = 100,
    filetypes_denylist = {
      "noice",
      "prompt",
      "TelescopePrompt",
      "TelescopeResults",
      "TelescopePreview",
      "telescope",
      "qf",
      "toggleterm",
      "lazy",
      "mason",
      "harpoon",
      "help",
      "coderunner",
      "NeogitStatus",
    },
    filetypes_allowlist = {},
    modes_denylist = {},
    modes_allowlist = {},
    providers_regex_syntax_denylist = {},
    providers_regex_syntax_allowlist = {},
    under_cursor = true,
  }

  vim.api.nvim_set_hl(0, "IlluminatedWordText", { underline = true })
  vim.api.nvim_set_hl(
    0,
    "IlluminatedWordRead",
    { bg = "NONE", bold = true, underline = true }
  )
  vim.api.nvim_set_hl(
    0,
    "IlluminatedWordWrite",
    { bg = "NONE", underline = true }
  )
end

return config
