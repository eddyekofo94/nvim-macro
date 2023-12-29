vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  once = true,
  group = vim.api.nvim_create_augroup('WinBarSetup', {}),
  callback = function()
    local static = require('utils.static')
    local winbar = require('plugin.winbar')
    local api = require('plugin.winbar.api')
    local utils = require('plugin.winbar.utils')
    local sources = require('plugin.winbar.sources')
    winbar.setup({
      general = {
        update_interval = 32,
        attach_events = {
          'LspAttach',
          'BufWinEnter',
          'BufWritePost',
        },
        enable = function(buf, win)
          return vim.fn.win_gettype(win) == ''
            and vim.wo[win].winbar == ''
            and vim.bo[buf].bt == ''
            and (
              vim.bo[buf].ft == 'markdown'
              or utils.treesitter.is_active(buf)
              or not vim.tbl_isempty(vim.tbl_filter(function(client)
                return client.supports_method('textDocument/documentSymbol')
              end, vim.lsp.get_clients({ bufnr = buf })))
            )
        end,
      },
      bar = {
        sources = function(buf)
          return vim.bo[buf].ft == 'markdown' and { sources.markdown }
            or {
              utils.source.fallback({
                sources.lsp,
                sources.treesitter,
              }),
            }
        end,
      },
      sources = {
        path = {
          modified = function(sym)
            return sym:merge({
              icon = static.icons.ui.DotLarge,
              icon_hl = 'CmpItemKindSnippet',
            })
          end,
        },
      },
    })

    vim.keymap.set('n', '<Leader>;', api.pick)
    vim.keymap.set('n', '[C', api.goto_context_start)
    vim.keymap.set('n', ']C', api.select_next_context)

    ---Set WinBar & WinBarNC background to Normal background
    ---@return nil
    local function clear_winbar_bg()
      local hl_normal = utils.hl.get(0, {
        name = 'Normal',
        link = false,
      })

      local function _clear_bg(name)
        local hl = utils.hl.get(0, { name = name, link = false })
        if hl_normal.bg ~= hl.bg or hl_normal.ctermbg ~= hl.ctermbg then
          hl.bg = hl_normal.bg
          hl.ctermbg = hl_normal.ctermbg
          vim.api.nvim_set_hl(0, name, hl)
        end
      end

      _clear_bg('WinBar')
      _clear_bg('WinBarNC')
    end

    clear_winbar_bg()

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('WinBarHlClearBg', {}),
      callback = clear_winbar_bg,
    })
    return true
  end,
})
