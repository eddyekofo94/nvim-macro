local get = require('utils/get')
local langs = require('utils/langs')

require 'nvim-treesitter.configs'.setup {
  -- One of 'all', 'maintained' (parsers with maintainers),
  -- or a list of languages
  ensure_installed = get.ts_list(langs),

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- List of parsers to ignore installing
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter
    -- at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled
    -- (like for indentation).
    -- Using this option may slow down your editor, and you may
    -- see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false
  },

  -- For nvim-ts-rainbow
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1024
  }
}
