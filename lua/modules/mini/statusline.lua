local stl_util = require "ui.statusline"

return { -- Collection of various small independent plugins/modules
  "echasnovski/mini.statusline",
  lazy = false,
  enabled = true,
  config = function()
    local statusline = require "mini.statusline"
    statusline.setup {
      set_vim_settings = false,
      use_icons = true,
      content = {
        active = function()
          local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
          local spell = vim.wo.spell and (statusline.is_truncated(120) and "S" or "SPELL") or ""
          local wrap = vim.wo.wrap and (statusline.is_truncated(120) and "W" or "WRAP") or ""
          local diagnostics = statusline.section_diagnostics { trunc_width = 75 }

          return statusline.combine_groups {
            { hl = mode_hl, strings = { mode, spell, wrap } },
            {
              hl = "StatuslineInactive",
              strings = { stl_util.project_name() },
            },
            { hl = "StatuslineFilename", strings = { stl_util.file_info() } },
            "%<", -- Mark general truncate point
            {
              hl = "StatuslineFilename",
              -- strings = { stl_util.diag() },
              strings = { diagnostics },
            },
            { hl = "StatuslineGitAdd", strings = { stl_util.macro() } },
            { hl = "StatusLine" },
            "%=", -- End left alignment
            {
              hl = "StatuslineInactive",
              strings = { stl_util.lsp() },
            },
            {
              hl = "StatuslineInactive",
              strings = { stl_util.lsp_progress() },
            },
            "%=",
            { hl = "StatusLine", strings = { stl_util.gitdiff() } },

            { hl = "MiniStatuslineInactive", strings = { stl_util.formatter() } },
            { hl = "StatuslineInactive", strings = { stl_util.info() } },
            {
              hl = mode_hl,
              strings = { stl_util.search_count(), stl_util.line_info() },
            },
          }
        end,
      },
    }
    vim.opt.laststatus = 3
  end,
}
