return {
  {
    "neovim/nvim-lspconfig",
    event = { "FileType" },
    cmd = { "LspInfo", "LspStart" },
    config = function()
      vim.schedule(function()
        require("configs.nvim-lspconfig")
      end)
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("configs.clangd_extensions")
    end,
  },

  {
    "dnlhc/glance.nvim",
    event = "LspAttach",
    config = function()
      require("configs.glance")
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-treesitter/nvim-treesitter",
      "rafaelsq/nvim-goc.lua",
    },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
    config = function()
      require("modules.lsp.go")
    end,
  },
}
