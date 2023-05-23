---@class winbar_configs_t
local opts = {
  bar = {
    pick = {
      pivots = 'abcdefghijklmnopqrstuvwxyz',
    },
  },
  menu = {
    keymaps = {
      ['<LeftMouse>'] = function()
        local menu = require('plugin.winbar.api').get_current_winbar_menu()
        if not menu then
          return
        end
        local mouse = vim.fn.getmousepos()
        if mouse.winid ~= menu.win then
          local parent_menu = _G.winbar.menus[mouse.winid]
          if parent_menu and parent_menu.sub_menu then
            parent_menu.sub_menu:close()
          end
          if vim.api.nvim_win_is_valid(mouse.winid) then
            vim.api.nvim_set_current_win(mouse.winid)
          end
          return
        end
        menu:click_at({ mouse.line, mouse.column })
      end,
      ['<CR>'] = function()
        local menu = require('plugin.winbar.api').get_current_winbar_menu()
        if not menu then
          return
        end
        local cursor = vim.api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
        if component then
          menu:click_on(component)
        end
      end,
    },
  },
}

---Set winbar options
---@param new_opts winbar_configs_t?
local function set(new_opts)
  opts = vim.tbl_deep_extend('force', opts, new_opts or {})
end

return {
  opts = opts,
  set = set,
}
