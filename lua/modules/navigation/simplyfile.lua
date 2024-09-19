return {
  "Rizwanelansyah/simplyfile.nvim",
  enabled = false,
  dependencies = {
    { "nvim-tree/nvim-web-devicons", opts = {} },
  },
  config = function()
    require("simplyfile").setup {
      border = {
        left = "rounded",
        main = "double",
        right = "rounded",
      },
      derfault_keymaps = true,
      keymaps = {
        ["q"] = function()
          -- return require("simplyfile").close()
        end,
        --- your custom keymaps
        --- {dir} have following field
        --- name: name of file/folder
        --- absolute: absolute path of file/folder
        --- icon: the nerd fonts icon
        --- hl: highlight group name for icon
        --- filetype: type of file
        --- is_folder: folder or not
        ["lhs"] = function(dir) --[[ some code ]]
        end,
      },
    }
    local lmap = require("utils.keymap.keymaps").set_leader_keymap

    lmap("-", function()
      require("simplyfile").open()
    end, "[SimplyFile] File explorer")
  end,
}
-- return function()
--   local mapping = require "simplyfile.mapping"
--   require("simplyfile").setup {
--     border = {
--       -- up = { " ", " ", " ", "┐", "┘", "─", "└", "┌" },
--       up = { "─", "─", "─", " ", "─", "─", "─", " " },
--       main = { "┬", "─", "┬", "│", "┴", "─", "┴", "│" },
--       left = { "┌", "─", "─", " ", "─", "─", "└", "│" },
--       right = { "─", "─", "┐", "│", "┘", "─", "─", " " },
--     },
--     keymaps = vim.tbl_extend("force", mapping.default, {
--       d = function(dir)
--         if not dir then
--           return
--         end
--         local pos = vim.api.nvim_win_get_cursor(0)
--         vim.ui.select({ "No", "Yes" }, { prompt = "Move To Trash? " }, function(item)
--           if item == "Yes" then
--             vim.cmd("silent !trash " .. dir.absolute)
--             ---@diagnostic disable-next-line: missing-fields
--             mapping.refresh { absolute = "" }
--             vim.api.nvim_win_set_cursor(0, { pos[1] > 1 and pos[1] - 1 or 1, pos[2] })
--           end
--         end)
--       end,
--       ["<CR>"] = function(dir)
--         if not dir then
--           return
--         end
--         if not dir.is_folder then
--           vim.cmd "SimplyFileClose"
--           vim.cmd("e " .. dir.absolute)
--         end
--       end,
--       ["+"] = function(dir)
--         if not dir then
--           return
--         end
--         if dir.is_folder then
--           return
--         end
--         local buf = vim.api.nvim_create_buf(false, true)
--         local win = vim.api.nvim_open_win(buf, true, {
--           relative = "editor",
--           col = 2,
--           row = 2,
--           width = vim.o.columns - 4,
--           height = vim.o.lines - 6,
--           border = "rounded",
--         })
--         vim.cmd("e " .. dir.absolute)
--         vim.api.nvim_set_option_value("readonly", true, { buf = buf })
--         vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
--         vim.api.nvim_buf_set_keymap(0, "n", "<ESC>", "", {
--           callback = function()
--             vim.api.nvim_buf_delete(0, { force = true })
--           end,
--         })
--       end,
--     }),
--     default_keymaps = true,
--     preview = {
--       show = function(dir)
--         if vim.endswith(dir.name, ".png") then
--           return false
--         else
--           return true
--         end
--       end,
--     },
--     clipboard = {
--       notify = true,
--     },
--   }
--   local map = require "which-key"
--   map.register({
--     f = {
--       name = "Find & Files",
--       n = { "<CMD>SimplyFileOpen<CR>", "Open File Explorer" },
--       e = {
--         function()
--           require("simplyfile").open(vim.fn.getcwd(0))
--         end,
--         "Open File Explorer On CWD",
--       },
--     },
--   }, {
--     prefix = "<leader>",
--   })
-- end
