local options = {
  ensure_installed = {
    "javascript",
    "markdown",
    "yaml",
    "vim",
    "go",
    "regex",
    "vimdoc",
    "json",
    "bash",
    "query",
    "fish",
    "lua",
    "luadoc",
    "cpp",
    "dockerfile",
    "python",
    "cpp",
    "c",
    "java",
    "gitcommit",
    "diff",
  },
  auto_install = true,
  sync_install = true,
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = function(_, bufnr)
      if vim.api.nvim_buf_line_count(bufnr) > 50000 then
        -- Disable in large number of line
        return true
      end
    end,
  },
  matchup = {
    -- enable = true,
    enable = function(_, buffer)
      if vim.bo[buffer.buf].filetype ~= "oil" then
        return
      end
      return true
    end,
    disable = function(_lang, buffer)
      return vim.api.nvim_buf_line_count(buffer) > 20000 or { "oil" }
      -- if vim.api.nvim_buf_line_count(buffer) > 20000 then
      --   return
      -- end
      -- return { "oil" }
    end,
  },
  autopairs = {
    -- BUG: this breaks nvim-autopairs
    enable = false,
  },
  refactor = {
    highlight_definitions = {
      lear_on_cursor_move = true,
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "R",
        },
      },
      enable = true,
    },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        -- mapping to rename reference under cursor
        smart_rename = "grr",
      },
    },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- automatically jump forward to matching textobj
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ib"] = "@block.inner",
        ["ab"] = "@block.outer",
        ["ir"] = "@parameter.inner",
        ["ar"] = "@parameter.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]]"] = "@function.outer",
        ["]b"] = "@parameter.outer",
        ["]l"] = "@block.inner",
        ["]e"] = "@function.inner",
        ["]a"] = "@attribute.inner",
        ["]s"] = "@this_method_call",
        ["]c"] = "@method_object_call",
        ["]o"] = "@object_declaration",
        ["]k"] = "@object_key",
        ["]v"] = "@object_value",
        ["]w"] = "@method_parameter",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]B"] = "@parameter.outer",
        ["]L"] = "@block.inner",
        ["]E"] = "@function.inner",
        ["]A"] = "@attribute.inner",
        ["]S"] = "@this_method_call",
        ["]C"] = "@method_object_call",
        ["]O"] = "@object_declaration",
        ["]K"] = "@object_key",
        ["]V"] = "@object_value",
        ["]W"] = "@method_parameter",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
        ["[b"] = "@parameter.outer",
        -- ["[d"] = "@block.inner",
        ["[e"] = "@function.inner",
        ["[a"] = "@attribute.inner",
        ["[s"] = "@this_method_call",
        ["[c"] = "@method_object_call",
        ["[o"] = "@object_declaration",
        ["[k"] = "@object_key",
        ["[v"] = "@object_value",
        ["[w"] = "@method_parameter",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
        ["[B"] = "@parameter.outer",
        ["[D"] = "@block.inner",
        ["[E"] = "@function.inner",
        ["[A"] = "@attribute.inner",
        ["[S"] = "@this_method_call",
        ["[C"] = "@method_object_call",
        ["[O"] = "@object_declaration",
        ["[K"] = "@object_key",
        ["[V"] = "@object_value",
        ["[W"] = "@method_parameter",
      },
    },
  },
}

return options
