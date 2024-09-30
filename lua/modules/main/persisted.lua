return {
  "olimorris/persisted.nvim",
  lazy = false,
  enabled = true,
  config = function()
    require("persisted").setup {
      silent = true, -- silent nvim message when sourcing session file
      use_git_branch = true, -- create session files based on the branch of the git enabled repository
      autosave = true, -- automatically save session files when exiting Neovim
      should_autosave = true, -- function to determine if a session should be autosaved
      autoload = true, -- automatically load the session for the cwd on Neovim startup
      on_autoload_no_session = function()
        vim.notify "No existing session to load."
      end,
      follow_cwd = true, -- change session file name to match current working directory if it changes
      allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
      ignored_dirs = {
        "~/.local/nvim",
        vim.fn.stdpath "data",
      },
      telescope = { -- options for the telescope extension
        reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
      },
    }
    require("telescope").load_extension "persisted"
  end,
}
