---@type LazySpec
return {
  --  INFO: 2024-06-24 - brew install yazi
  "mikavilpas/yazi.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = true,
  event = "VeryLazy",
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>-",
      function()
        require("yazi").yazi()
      end,
      desc = "Open the file manager",
    },
    {
      -- Open in the current working directory
      "<leader>cw",
      function()
        require("yazi").yazi(nil, vim.fn.getcwd())
      end,
      desc = "Open the file manager in nvim's working directory",
    },
  },
  ---@type YaziConfig
  opts = {
    open_for_directories = false,
  },
}
