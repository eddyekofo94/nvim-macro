return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup {
      automatic_installation = true,
      ensure_installed = {
        "lua_ls",
        "vimls",
        "rust_analyzer",
        "yamlls",
        "gopls",
        "pylsp",
        "clangd",
        "bashls",
        "sqlls",
        "cmake",
        "gopls",
        "glint",
        "dockerls",
      },
    }
  end,
  opts = {
    ensure_installed = {
      "lua-language-server",
      "shellcheck",
      "selene",
      "shfmt",
      "flake8",
      "prettier",
      "vim-language-server",
      "stylua",
      "json-lsp",
      "marksman",
      "yamlls",
      "pylsp",
      "bashls",
      "sqlls",
      "dockerls",
      "glint",
      "gopls",
      "clangd",
    },
  },
}
