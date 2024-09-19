local hl = require "utils.hl"
local sethl_groups = hl.sethl_groups

local icons = {
  GitSignAdd = "│",
  GitSignChange = "│",
  GitSignChangedelete = "│",
  GitSignDelete = "▁",
  GitSignTopdelete = "▔",
  GitSignUntracked = "┆",
}

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  enabled = true,
  config = function()
    if not package.loaded.trouble then
      package.preload.trouble = function()
        return true
      end
    end
    require("gitsigns").setup {
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      signs_staged = {
        add = { text = vim.trim(icons.GitSignAdd), numhl = "GitSignsAddNr" },
        untracked = { text = vim.trim(icons.GitSignUntracked) },
        change = { text = vim.trim(icons.GitSignChange), numhl = "GitSignsChangeNr" },
        delete = { text = vim.trim(icons.GitSignDelete), numhl = "GitSignsDeleteNr" },
        topdelete = { text = vim.trim(icons.GitSignTopdelete), numhl = "GitSignDelete" },
        changedelete = { text = vim.trim(icons.GitSignChangedelete), numhl = "GitSignsChangeNr" },
      },
      signs = {
        add = { text = vim.trim(icons.GitSignAdd) },
        untracked = { text = vim.trim(icons.GitSignUntracked) },
        change = { text = vim.trim(icons.GitSignChange) },
        delete = { text = vim.trim(icons.GitSignDelete) },
        topdelete = { text = vim.trim(icons.GitSignTopdelete) },
        changedelete = { text = vim.trim(icons.GitSignChangedelete) },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local map = require("utils.keymap.keymaps").set_keymap
        local function opts(desc)
          return { expr = true, desc = desc, buffer = bufnr }
        end

        local hlgroups = {
          GitSignsAddNr = { link = "GitSignsAddNr" },
          GitSignsChangeNr = { link = "GitSignsChangeNr" },
          GitSignsChangedeleteNr = { link = "GitSignsChangeNr" },
          GitSignsDeleteNr = { link = "GitSignsDeleteNr" },
          GitSignsTopdeleteNr = { link = "GitSignDelete" },
        }

        sethl_groups(hlgroups)

        -- Navigation
        map({ "n", "x" }, "]x", function()
          if vim.wo.diff then
            vim.api.nvim_feedkeys(vim.v.count1 .. "]x", "n", true)
            return
          end
          for _ = 1, vim.v.count1 do
            gs.next_hunk()
          end
        end, "Next Hunk")

        map({ "n", "x" }, "[x", function()
          if vim.wo.diff then
            vim.api.nvim_feedkeys(vim.v.count1 .. "xc", "n", true)
            return
          end
          for _ = 1, vim.v.count1 do
            gs.prev_hunk()
          end
        end, "Prev Hunk")

        map("x", "<leader>gg", function()
          gs.stage_hunk {
            vim.fn.line ".",
            vim.fn.line "v",
          }
        end, opts "Stage Hunk")

        map("x", "<leader>gx", function()
          gs.reset_hunk {
            vim.fn.line ".",
            vim.fn.line "v",
          }
        end, opts "Reset Hunk")

        map("n", "<leader>gg", gs.stage_hunk, "Stage Hunk")
        map({ "n", "v" }, "<leader>gx", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>gG", gs.stage_buffer, opts "Stage Buffer")
        map("n", "<leader>gu", gs.undo_stage_hunk, opts "Undo Stage Hunk") --  BUG: 2024-07-01 - Seems to be broken
        map("n", "<leader>gX", gs.reset_buffer_index, opts "Reset Buffer") --  BUG: 2024-04-22 - This is not working
        map("n", "<leader>gL", gs.toggle_current_line_blame, "toggle blame line")
        map("n", "<leader>gv", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>gq", gs.setqflist, "Hunk quickfix")
        map("n", "<leader>gV", gs.preview_hunk, "Inline Preview Hunk")
        map("n", "<leader>gb", function()
          gs.blame_line { full = true }
        end, opts "Blame Line")
        map("n", "<leader>gd", gs.diffthis, opts "Diff This")
        map("n", "<leader>gD", function()
          gs.diffthis "~"
        end, opts "Diff This ~")
        map({ "o", "x" }, "ih", "<cmd>C-U>Gitsigns select_hunk<CR>", opts "GitSigns Select Hunk")

        map({ "o", "x" }, "ic", ":<C-U>Gitsigns select_hunk<CR>", opts "select hunk")
        map({ "o", "x" }, "ac", ":<C-U>Gitsigns select_hunk<CR>", opts "select hunk")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
      end,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        ignore_whitespace = false,
        delay = 100,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }
    package.loaded.trouble = nil
    package.preload.trouble = nil
  end,
}
