local static = require('utils.static')
local M = {}

---@class winbar_configs_t
M.opts = {
  general = {
    ---@type boolean|fun(buf: integer, win: integer): boolean
    enable = function(buf, win)
      return not vim.api.nvim_win_get_config(win).zindex
        and vim.bo[buf].buftype == ''
        and vim.api.nvim_buf_get_name(buf) ~= ''
        and not vim.wo[win].diff
    end,
    update_events = {
      'CursorHold',
      'CursorHoldI',
      'DirChanged',
      'FileChangedShellPost',
      'TextChanged',
      'VimResized',
      'WinResized',
      'WinScrolled',
    },
  },
  symbol = {
    icons = {
      kinds = static.icons.kinds,
      ui = static.icons.ui,
    },
  },
  bar = {
    ---@type winbar_source_t[]|fun(buf: integer, win: integer): winbar_source_t[]
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
    pick = {
      pivots = 'abcdefghijklmnopqrstuvwxyz',
    },
  },
  menu = {
    ---@type table<string, function|table<string, function>>
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
      ---@type string|fun(buf: integer): string
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
function M.set(new_opts)
  M.opts = vim.tbl_deep_extend('force', M.opts, new_opts or {})
end

---Evaluate a dynamic option value (with type T|fun(...): T)
---@generic T
---@param opt T|fun(...): T
---@return T
function M.eval(opt, ...)
  if type(opt) == 'function' then
    return opt(...)
  end
  return opt
end

return M
