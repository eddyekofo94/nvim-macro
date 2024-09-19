return {
  "dgagn/diagflow.nvim",
  enabled = true,
  config = function()
    require("diagflow").setup {
      -- toggle_event = { "InsertLeave" },
      enable = function()
        return vim.bo.filetype ~= "lazy"
      end,
      inline_padding_left = 5,
      placement = "top", -- inline
      text_align = "right", -- 'left', 'right'
      show_sign = true, -- set to true if you want to render the diagnostic sign before the diagnostic message
      scope = "cursor", -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
    }
  end,
}
