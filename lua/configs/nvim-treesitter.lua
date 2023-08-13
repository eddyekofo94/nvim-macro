local ts_configs = require('nvim-treesitter.configs')
local utils = require('utils')

-- Get all filetypes that have treesitter parsers
local ts_filetypes = {}
local langs = require('utils.static').langs
for lang, _ in pairs(langs) do
  if langs[lang].ts then
    table.insert(ts_filetypes, langs[lang].ft)
  end
end

-- Set treesitter folds
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TSFolds', {}),
  callback = function(info)
    vim.schedule(function()
      if utils.treesitter.ts_active(info.buf) then
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
      end
    end)
  end,
})

vim.api.nvim_create_autocmd('CmdWinEnter', {
  group = vim.api.nvim_create_augroup('CmdWinRegexVimHl', {}),
  desc = 'Use regex vim highlight in command window.',
  callback = function(info)
    if info.match == ':' then
      vim.cmd('TSBufDisable highlight')
    end
  end,
})

---@diagnostic disable-next-line: missing-fields
ts_configs.setup({
  ensure_installed = require('utils.static').langs:list('ts'),
  sync_install = true,
  ignore_install = {},
  highlight = {
    enable = not vim.g.vscode,
    disable = { 'markdown', 'tex', 'latex' },
    additional_vim_regex_highlighting = false,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  endwise = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
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
        ['a*'] = '@comment.outer',
        ['ao'] = '@block.outer',
        ['io'] = '@block.inner',
        ['a?'] = '@conditional.outer',
        ['i?'] = '@conditional.inner',
      },
    },
    move = {
      enable = true,
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
      swap_next = {
        ['<M-C-L>'] = '@parameter.inner',
      },
      swap_previous = {
        ['<M-C-H>'] = '@parameter.inner',
      },
    },
    lsp_interop = {
      enable = true,
      border = 'shadow',
      peek_definition_code = {
        ['<C-k>'] = '@function.outer',
      },
    },
  },
})
