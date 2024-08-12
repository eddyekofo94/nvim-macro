return {
  "SmiteshP/nvim-navic",
  enabled = true,
  config = function()
    require("nvim-navic").setup {
      highlight = true,
      click = true,
      lsp = {
        auto_attach = true,
        preference = nil,
      },
    }
    -- This is where I have navic all setup
    -- require "ui.winbar"
    -- vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
}
