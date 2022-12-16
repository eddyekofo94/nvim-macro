local M = {}

M['nvim-treesitter'] = function()
  local ts_configs = require('nvim-treesitter.configs')
  ts_configs.setup({
    ensure_installed = require('utils.static').langs:list('ts'),
    sync_install = true,
    ignore_install = {},
    highlight = {
      enable = not vim.g.vscode,
      additional_vim_regex_highlighting = false,
    },
    context_commentstring = {
      enable = true,
    },
    rainbow = {
      enable = not vim.g.vscode,
      extended_mode = true,
      max_file_lines = 1024,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'van',
        node_incremental = 'an',
        scope_incremental = 'aN',
        node_decremental = 'in',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['am'] = '@function.outer',
          ['im'] = '@function.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ak'] = '@class.outer',
          ['ik'] = '@class.inner',
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['a/'] = '@comment.outer',
          ['i/'] = '@comment.inner',
          ['a*'] = '@comment.outer',
          ['i*'] = '@comment.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@function.outer',
          [']k'] = '@class.outer',
          [']}'] = '@class.outer',
          [']a'] = '@parameter.outer'
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@function.outer',
          [']K'] = '@class.outer',
          [']{'] = '@class.outer',
          [']A'] = '@parameter.outer'
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@function.outer',
          ['[k'] = '@class.outer',
          ['[{'] = '@class.outer',
          ['[a'] = '@parameter.outer'
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@function.outer',
          ['[K'] = '@class.outer',
          ['[}'] = '@class.outer',
          ['[A'] = '@parameter.outer'
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<C-l>'] = '@parameter.inner'
        },
        swap_previous = {
          ['<C-h>'] = '@parameter.inner'
        },
      },
      lsp_interop = {
        enable = true,
        border = 'single',
        peek_definition_code = {
          ['<leader>p'] = '@function.outer',
        },
      },
    },
  })
end

return M
