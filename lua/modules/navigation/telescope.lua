return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    init = function()
      --   local telescope = require "telescope"
      --   local Telescope = require "utils.telescope"
      --
      --   vim.api.nvim_create_autocmd("BufWinEnter", {
      --     nested = true,
      --     callback = function(info)
      --       local path = info.file
      --       if path == "" then
      --         return
      --       end
      --       local stat = vim.uv.fs_stat(path)
      --       if stat and stat.type == "directory" then
      --         vim.api.nvim_del_autocmd(info.id)
      --         -- return Telescope.find("files", { cwd = "%:p:h" })
      --         return telescope.extensions.file_browser.file_browser { path = "%:p:h", bufnr = 0 }
      --       end
      --     end,
      --   })
    end,
    dependencies = {
      {
        --  NOTE: 2024-05-30 - Fedora: sudo dnf install sqlite sqlite-devel sqlite-tcl
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        dependencies = {
          "kkharji/sqlite.lua",
          -- Only required if using match_algorithm fzf
          { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
          -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
          { "nvim-telescope/telescope-fzy-native.nvim" },
        },
      },
      {
        "LukasPietzschmann/telescope-tabs",
        config = function()
          require("telescope").load_extension "telescope-tabs"
          require("telescope-tabs").setup {
            -- Your custom config :^)
          }
        end,
        dependencies = { "nvim-telescope/telescope.nvim" },
      },
      {
        "tingey21/telescope-colorscheme-persist.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = false,
        config = function()
          require("telescope-colorscheme-persist").setup {}
        end,
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      },
      "nvim-lua/plenary.nvim",
      { "kyoh86/telescope-windows.nvim" },
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      { "nvim-telescope/telescope-frecency.nvim" },
      {
        "ahmedkhalf/project.nvim",
        event = "VeryLazy",
        config = function()
          require("project_nvim").setup {
            scope_chdir = "global",
          }
        end,
      },
      {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
          require("window-picker").setup()
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      "jvgrootveld/telescope-zoxide",
      {
        "prochri/telescope-picker-history-action",
        opts = true,
      },
    },
    config = function()
      local actions = require "telescope.actions"
      local Util = require "utils.telescope"
      local themes = require "telescope.themes"
      local extensions = require("telescope").extensions
      local telescope = require "telescope"
      local action_state = require "telescope.actions.state"

      local utils = require "utils"
      local icons = utils.static.icons
      -- local maps = utils.keymap.keymaps:empty_map_table()

      local previewers = require "telescope.previewers"
      local state = require "telescope.state"
      local builtin = require "telescope.builtin"
      local Telescope = require "utils.telescope"
      -- local TelescopePickers = require "utils.telescope_pickers"
      local keymap_utils = require "utils.keymap.keymaps"
      local map = keymap_utils.set_keymap
      local lmap = keymap_utils.set_leader_keymap

      -- https://github.com/nvim-telescope/telescope.nvim/issues/2602#issuecomment-1636809235
      local slow_scroll = function(prompt_bufnr, direction)
        local previewer = action_state.get_current_picker(prompt_bufnr).previewer
        local status = state.get_status(prompt_bufnr)

        -- Check if we actually have a previewer and a preview window
        if type(previewer) ~= "table" or previewer.scroll_fn == nil or status.preview_win == nil then
          return
        end

        previewer:scroll_fn(1 * direction)
      end

      local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        filepath = vim.fn.expand(filepath)
        vim.loop.fs_stat(filepath, function(_, stat)
          if not stat then
            return
          end
          if stat.size > 100000 then
            return
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end)
      end

      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            -- "--trim", -- INFO: trim the indentation at the beginning
            "--glob=!.git/",
          },
          prompt_prefix = "   ",
          -- selection_caret = "  ",
          selection_caret = "  ",
          git_worktrees = vim.g.git_worktrees,
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          pickers = {
            -- frecency = {},
            live_grep = {
              --@usage don't include the filename in the search results
              only_sort_text = true,
            },
            grep_string = {
              only_sort_text = true,
            },
            git_files = {
              mappings = {
                n = {
                  ["<C-H>"] = Util.send_to_harpoon_action,
                },
                i = {
                  ["<C-H>"] = Util.send_to_harpoon_action,
                },
              },
            },
            find_files = {
              find_command = {
                "rg",
                "--hidden",
                "--no-heading",
                "--with-filename",
                "--files",
                "--sortr=modified",
                "--column",
                "--smart-case",
                "--ignore-file",
                "--iglob",
                "!.git",
              },
              mappings = {
                n = {
                  ["<C-H>"] = Util.send_to_harpoon_action,
                },
                i = {
                  ["<C-H>"] = Util.send_to_harpoon_action,
                },
              },
            },
            colorscheme = {
              enable_preview = true,
              ignore_builtins = true,
            },
            buffers = {
              sort_mru = true,
              ignore_current_buffer = true,
              theme = "dropdown",
              select_current = false,
              mappings = {
                i = {
                  ["<C-e>"] = actions.delete_buffer,
                  -- ["<C-e>"] = builtin.buffers(),
                },
                -- n = {
                --   ["<C-e>"] = actions.delete_buffer(),
                --   ["l"] = "select_default",
                -- },
              },
            },
          },
          file_ignore_patterns = {
            "node_modules/.*",
            ".cache",
            "build/",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("mini.fuzzy").get_telescope_sorter,
          path_display = { "filename_first" },
          dynamic_preview_title = true,
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          buffer_previewer_maker = new_maker,
          mappings = {
            n = { ["q"] = actions.close },
            i = {
              ["<C-d>"] = function(bufnr)
                slow_scroll(bufnr, 1)
              end,
              ["<C-b>"] = function(bufnr)
                slow_scroll(bufnr, -1)
              end,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-t>"] = actions.select_tab,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-u>"] = false, --  INFO: 2024-02-19 09:24 AM - Resets prompt
              -- Add up multiple actions
              ["<CR>"] = actions.select_default + actions.center,
              ["<C-,>"] = function()
                require("telescope-picker-history-action").prev_picker()
              end,
              ["<C-.>"] = function()
                require("telescope-picker-history-action").next_picker()
              end,
              ["<C-i>"] = function()
                Util.find("files", { hidden = true, no_ignore = true })()
              end,
              -- ["<C-h>"] = function()
              --   Util.find("files", { hidden = true })()
              -- end,
              ["<C-p>"] = function(prompt_bufnr)
                -- Use nvim-window-picker to choose the window by dynamically attaching a function
                local action_set = require "telescope.actions.set"

                local picker = action_state.get_current_picker(prompt_bufnr)
                picker.get_selection_window = function(picker, entry)
                  local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
                  -- Unbind after using so next instance of the picker acts normally
                  picker.get_selection_window = nil
                  return picked_window_id
                end

                return action_set.edit(prompt_bufnr, "edit")
              end,
            },
          },
          cache_picker = {
            -- we need to have a picker history we can work with
            num_pickers = 50,
          },
        },

        extensions_list = {
          "file_browser",
          "zoxide",
          "ui-select",
          "frecency",
          "refactoring",
          "projects",
          "themes",
          "terms",
          "fzf",
          "windows",
          "smart_open",
        },

        extensions = {
          smart_open = {
            match_algorithm = "fzf", -- default: fzy
            show_scores = true,
            open_buffer_indicators = { previous = icons.Diamond, others = icons.DotLarge },
          },
          file_browser = {
            -- theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
          },
          ["ui-select"] = {
            themes.get_dropdown {},
          },
          frecency = {
            show_scores = true, -- TODO: remove when satisfied
            auto_validate = true,
            hide_current_buffer = true,
            db_safe_mode = false,
            show_unindexed = false,
            ignore_patterns = { "*/tmp/*", "*/undodir/*" },
            workspaces = {
              ["nvim"] = vim.fn.stdpath "config",
              ["dotfiles"] = os.getenv "HOME" .. "/.dotfiles/",
            },
          },
          persisted = {
            theme_conf = { winblend = 10, border = true },
            layout_config = { width = 0.55, height = 0.55 },
            previewer = false,
          },
          -- zoxide = {
          --   themes.get_dropdown {},
          -- },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }

      -- Slightly advanced example of overriding default behavior and theme
      map("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, "[/] Fuzzily search in current buffer")

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      map("n", "<leader>s/", function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end, "[S]earch [/] in Open Files")

      map("n", "<leader>sc", function()
        builtin.commands()
      end, "[S]earch [C]ommands")

      map("n", "<leader>;", function()
        telescope.extensions.file_browser.file_browser { path = "%:p:h", bufnr = 0 }
      end, "[Tel] file browser")

      map("n", "<leader><space>", function()
        extensions.smart_open.smart_open()
      end, "Smart open")

      lmap("p", Telescope.find "files", "Find files (cwd)")

      lmap("'", Telescope.find("files", { cwd = "%:p:h" }), "Find files current dir")

      lmap("sa", Telescope.find("files", { follow = true, no_ignore = true, hidden = true }, "[S]earch all"))

      lmap("ss", Telescope.find("live_grep", { cwd = utils.fs:get_root() }), "[Root] Live grep")

      lmap("sG", Telescope.find("live_grep", { cwd = "%:p:h" }), "[Cur] Live grep")

      lmap("sx", Telescope.find "git_status", "Open changed file")

      lmap("bb", Telescope.find("buffers", { cwd = false }), "[All] List buffers")

      lmap("s,", "<cmd>Telescope frecency<cr>", "[Root] Frecency")

      lmap("sb", Telescope.find "buffers", "[Root] List buffers")

      lmap("sH", Telescope.find "highlights", "[H]ighlights")

      lmap("sk", Telescope.find "keymaps", "Keymaps")

      lmap("so", Telescope.find "oldfiles", "Find oldfiles")

      lmap("sw", function()
        require("telescope").extensions.windows.list()
      end, "Find windows")

      lmap("sO", Telescope.find("oldfiles", { cwd = false }), "[Root] Find oldfiles")
      lmap("sp", "<cmd> Telescope projects<CR>", "Find projects")
      lmap("sz", "<cmd> Telescope zoxide list<CR>", "Find zoxide")
      lmap("sr", Telescope.find "resume", "Telescope Resume")
      lmap("sh", function()
        builtin.help_tags()
      end, "Vim Help Tags")

      lmap(":", Telescope.find "command_history", "Command history")

      lmap("s*", Telescope.find "grep_string", "Grep String [Root]")
      lmap("*", Telescope.find("grep_string", { cwd = false }), "Grep String")

      lmap("sd", Telescope.find("diagnostics", { bufnr = 0 }), "Find diagnostics buffer")
      lmap("sD", Telescope.find "diagnostics", "Find diagnostics [Root]")

      -- INFO: LukasPietzschmann/telescope-tabs
      lmap("st", "<cmd>Telescope telescope-tabs list_tabs<CR>", "[T]elescope[T]abs List")

      -- maps.n["<leader>lO"] = {
      --   TelescopePickers.lsp_outgoing_calls(),
      --   desc = "Inc calls",
      -- }

      -- maps.n["<leader>sI"] = {
      --   TelescopePickers.lsp_incoming_calls(),
      --   desc = "Inc calls",
      -- }

      map(
        { "n", "x" },
        "<c-]>",
        Telescope.find("lsp_definitions", { jump_type = "vsplit", reuse_win = true }),
        "Lsp definition"
      )

      lmap("sc", Telescope.config_files(), "Search Configs")

      lmap("s.", Telescope.dotfiles(), "Search dotfiles")

      lmap("sL", function()
        require("telescope.builtin").find_files { cwd = require("lazy.core.config").options.root }
      end, "[Lazy] Find Plugin File")

      -- keymap_utils.set_mappings(maps)

      vim.api.nvim_create_autocmd("User", {
        desc = "setup number and wrap for telescope previewer",
        pattern = "TelescopePreviewerLoaded",
        callback = function(args)
          vim.wo.number = true
          vim.wo.wrap = true
        end,
      })
    end,
  },
}
