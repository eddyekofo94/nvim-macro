return {
  -- Examples:
  --  - va)  - [V]isually select [A]round []paren
  --  - yinq - [Y]ank [I]nside [N]ext [']quote
  --  - ci'  - [C]hange [I]nside [']quote
  "echasnovski/mini.ai",
  event = "BufReadPre",
  dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
  init = function()
    -- no need to load the plugin, since we only need its queries
    require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
  end,
  config = function()
    local ai = require "mini.ai"
    local extras = require "mini.extra"

    ai.setup {
      n_lines = 500,
      custom_textobjects = {
        b = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer", "@function.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner", "@function.inner" },
        }, {}),
        c = ai.gen_spec.treesitter({
          a = "@class.outer",
          i = "@class.inner",
        }, {}),
        B = extras.gen_ai_spec.buffer(),
        D = extras.gen_ai_spec.diagnostic(),
        I = extras.gen_ai_spec.indent(),
        L = extras.gen_ai_spec.line(),
        N = extras.gen_ai_spec.number(),
      },
    }
  end,
}
