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
        enable = function(buf, win)
          return vim.fn.win_gettype(win) == ''
            and vim.wo[win].winbar == ''
            and vim.bo[buf].bt == ''
            and (
              vim.bo[buf].ft == 'markdown'
              or utils.treesitter.is_active(buf)
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
    return true
  end,
})
