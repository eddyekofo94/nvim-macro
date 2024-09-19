return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  lazy = false,
  enabled = true,
  init = function()
    vim.api.nvim_create_autocmd("BufReadCmd", {
      once = true,
      pattern = "VimEnter",
      group = vim.api.nvim_create_augroup("LoadSession", {}),
      callback = function()
        require("persistence").load()
        return true
      end,
    })
  end,
  opts = {},
  -- config = true,
}
