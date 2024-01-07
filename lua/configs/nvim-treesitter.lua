local ts_configs = require('nvim-treesitter.configs')
local utils = require('utils')

-- Set treesitter folds
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TSFolds', {}),
  callback = function(info)
    vim.schedule(function()
      if
        utils.treesitter.is_active(info.buf)
        and vim.opt_local.foldmethod:get() ~= 'diff'
        and not utils.opt.foldexpr:last_set_from('modeline')
        and not utils.opt.foldmethod:last_set_from('modeline')
      then
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
      end
      if utils.treesitter.is_active(info.buf) then
        vim.opt_local.foldtext = 'v:lua.vim.treesitter.foldtext()'
      end
    end)
  end,
})

---@param buf integer buffer handler
---@return boolean
local function buf_exceeds_limit(_, buf)
  return vim.b[buf].midfile == true
end

---@diagnostic disable-next-line: missing-fields
ts_configs.setup({
  ensure_installed = require('utils.static').langs:list('ts'),
  sync_install = false,
  ignore_install = {},
  highlight = {
    enable = not vim.g.vscode,
    disable = function(ft, buf)
      -- We will manually apply treesitter highlighting in markdown
      -- files in syntax/markdown.vim to get better inline code
      -- highlighting while still preserving math conceal provided
      -- by vimtex regex syntax rules
      return ft == 'markdown'
        or ft == 'tex'
        or buf_exceeds_limit(ft, buf)
        or vim.fn.win_gettype() == 'command'
    end,
    additional_vim_regex_highlighting = false,
  },
  endwise = {
    enable = true,
    disable = buf_exceeds_limit,
  },
  incremental_selection = {
    enable = true,
    disable = buf_exceeds_limit,
    keymaps = {
      init_selection = false,
      node_incremental = 'an',
      scope_incremental = 'aN',
      node_decremental = 'in',
    },
  },
  indent = {
    enable = true,
    disable = function(ft, buf)
      -- We will use treesitter indent expr in markdown
      -- files in indent/markdown.vim to get better alignment
      -- for math block and list items
      return vim.tbl_contains({ 'markdown', 'tex', 'latex' }, ft)
        or buf_exceeds_limit(ft, buf)
    end,
  },
  textobjects = {
    select = {
      enable = true,
      disable = buf_exceeds_limit,
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
        ['a*'] = '@comment.outer',
        ['ao'] = '@block.outer',
        ['io'] = '@block.inner',
        ['a?'] = '@conditional.outer',
        ['i?'] = '@conditional.inner',
      },
    },
    move = {
      enable = true,
      disable = buf_exceeds_limit,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']l'] = '@loop.outer',
        [']]'] = '@function.outer',
        [']k'] = '@class.outer',
        [']a'] = '@parameter.outer',
        [']o'] = '@block.outer',
        [']?'] = '@conditional.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']L'] = '@loop.outer',
        [']['] = '@function.outer',
        [']K'] = '@class.outer',
        [']A'] = '@parameter.outer',
        [']/'] = '@comment.outer',
        [']*'] = '@comment.outer',
        [']O'] = '@block.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[l'] = '@loop.outer',
        ['[['] = '@function.outer',
        ['[k'] = '@class.outer',
        ['[a'] = '@parameter.outer',
        ['[/'] = '@comment.outer',
        ['[*'] = '@comment.outer',
        ['[o'] = '@block.outer',
        ['[?'] = '@conditional.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[L'] = '@loop.outer',
        ['[]'] = '@function.outer',
        ['[K'] = '@class.outer',
        ['[A'] = '@parameter.outer',
        ['[O'] = '@block.outer',
      },
    },
    swap = {
      enable = true,
      disable = buf_exceeds_limit,
      swap_next = {
        ['<M-C-L>'] = '@parameter.inner',
      },
      swap_previous = {
        ['<M-C-H>'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      disable = buf_exceeds_limit,
      border = 'solid',
      peek_definition_code = {
        ['<Leader>K'] = '@function.outer',
      },
    },
  },
})
