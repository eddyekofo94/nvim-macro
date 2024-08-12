return {
  {
    "simonmclean/triptych.nvim",
    event = "VeryLazy",
    enabled = true,
    init = function()
      -- vim.api.nvim_create_autocmd("BufWinEnter", {
      --   nested = true,
      --   callback = function(info)
      --     local path = info.file
      --     if path == "" then
      --       return
      --     end
      --     local stat = vim.uv.fs_stat(path)
      --     if stat and stat.type == "directory" then
      --       local triptych = require "triptych"
      --       vim.api.nvim_del_autocmd(info.id)
      --       -- return Telescope.find("files", { cwd = "%:p:h" })
      --       return triptych.toggle_triptych()
      --     end
      --   end,
      -- })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
      "<leader>-",
      "<cmd>Triptych<CR>",
      "[Triptych] File explorer",
    },
    config = function()
      local lmap = require("utils.keymap.keymaps").set_leader_keymap

      lmap("-", "<cmd>Triptych<CR>", "[Triptych] File explorer")
      require("triptych").setup {
        mappings = {
          nav_left = { "h", "-" },
          quit = { "q", "<esc>" },
        },
        highlights = { -- Highlight groups to use. See `:highlight` or `:h highlight`
          file_names = "NONE",
          directory_names = "NONE",
        },
        extension_mappings = {
          ["<c-.>"] = {
            mode = "n",
            fn = function(target)
              require("telescope.builtin").find_files {
                search_dirs = { target.path },
              }
            end,
          },
          ["<c-/>"] = {
            mode = "n",
            fn = function(target)
              require("telescope.builtin").live_grep {
                search_dirs = { target.path },
              }
            end,
          },
        },
      }
    end,
  },
}
