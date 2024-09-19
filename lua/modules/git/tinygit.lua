return { -- lightweight git client
  "chrisgrieser/nvim-tinygit",
  event = "VeryLazy", -- load for status line component
  -- ft = "gitrebase", -- so ftplugin is loaded
  enabled = false,
  keys = function()
    local tinygit = require "tinygit"
    -- stylua: ignore start
    return {
      { "<leader>gtc", function() tinygit.smartCommit { pushIfClean = true } end, desc = "󰊢 Smart-Commit & Push" },
      { "<leader>gtC", function() tinygit.smartCommit { pushIfClean = false } end, desc = "󰊢 Smart-Commit" },
      { "<leader>gtp", function() tinygit.push { pullBefore = true } end, desc = "󰊢 Pull & Push" },
      { "<leader>gtP", function() tinygit.push { createGitHubPr = true } end, desc = " Push & PR" },
      { "<leader>gtf", function() tinygit.fixupCommit({ autoRebase = true }) end, desc = "󰊢 Fixup & Rebase" },
     { "<leader>gtm", function() tinygit.amendNoEdit { forcePushIfDiverged = true } end, desc = "󰊢 Amend-No-Edit & F-Push" },
      { "<leader>gtM", function() tinygit.amendOnlyMsg { forcePushIfDiverged = true } end, desc = "󰊢 Amend Only Msg & F-Push" },
      { "<leader>gti", function() tinygit.issuesAndPrs { state = "open" } end, desc = " Open Issues" },
      { "<leader>gtI", function() tinygit.issuesAndPrs { state = "closed" } end, desc = " Closed Issues" },
      { "<leader>gtd", function() tinygit.searchFileHistory() end, desc = "󰢷 File History" },
      { "<leader>gtD", function() tinygit.functionHistory() end, desc = "󰢷 Function History" },
      { "<leader>gtu", function() tinygit.githubUrl() end, mode = { "n", "x" }, desc = " GitHub URL" },
      { "<leader>gtU", function() tinygit.githubUrl("repo") end, desc = " Repo URL" },
      { "<leader>gt#", function() tinygit.openIssueUnderCursor() end, desc = " Open Issue under Cursor" },
      { "<leader>utc", function() tinygit.undoLastCommit() end, desc = "󰊢 Undo Last Commit" },
    }
    -- stylua: ignore end
  end,
  opts = {
    commitMsg = {
      conventionalCommits = { enforce = true },
      spellcheck = true,
      keepAbortedMsgSecs = 300,
    },
    historySearch = {
      autoUnshallowIfNeeded = true,
      diffPopup = {
        width = 0.9,
        height = 0.9,
        border = vim.g.borderStyle,
      },
    },
    statusline = {
      blame = {
        hideAuthorNames = { "Chris Grieser", "chrisgrieser" },
        ignoreAuthors = { "🤖 automated" },
        maxMsgLen = 60,
      },
    },
  },
  config = function(_, opts)
    require("tinygit").setup(opts)
  end,
}
