local static = require('utils.static')

---@class winbar_configs_t
local opts = {
  general = {
    ---@param buf integer
    ---@param win integer
    ---@return boolean
    enable = function(buf, win)
      return not vim.api.nvim_win_get_config(win).zindex
        and vim.bo[buf].buftype == ''
        and vim.api.nvim_buf_get_name(buf) ~= ''
        and not vim.wo[win].diff
    end,
  },
  symbol = {
    icons = static.icons.kinds,
  },
  bar = {
    ---@return winbar_source_t[]
    sources = function(_, _)
      local sources = require('plugin.winbar.sources')
      return {
        sources.path,
        {
          get_symbols = function(buf, cursor)
            for _, source in ipairs({
              sources.lsp,
              sources.treesitter,
              sources.markdown,
            }) do
              local symbols = source.get_symbols(buf, cursor)
              if not vim.tbl_isempty(symbols) then
                return symbols
              end
            end
            return {}
          end,
        },
      }
    end,
    icons = {
      separator = static.icons.ui.AngleRight,
      extends = vim.opt.listchars:get().extends or static.icons.ui.Ellipsis,
    },
    pick = {
      pivots = 'abcdefghijklmnopqrstuvwxyz',
    },
  },
  menu = {
    icons = {
      indicator = static.icons.ui.AngleRight,
    },
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
  sources = {
    path = {
      ---@param buf integer
      ---@return string?
      relative_to = function(buf)
        return require('utils.funcs.fs').proj_dir(
          vim.api.nvim_buf_get_name(buf)
        ) or vim.fn.getcwd()
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
