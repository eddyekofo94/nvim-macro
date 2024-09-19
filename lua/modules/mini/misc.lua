return {
  "echasnovski/mini.misc",
  config = function()
    require("mini.misc").setup()
    -- MiniMisc.setup_auto_root { "go.mod", ".git", "Makefile", "cwd", ".obsidian" }
    MiniMisc.setup_restore_cursor()
  end,
}
