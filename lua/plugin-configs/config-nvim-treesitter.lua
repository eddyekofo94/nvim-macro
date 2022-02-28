local get = require('utils/get')
local langs = require('utils/shared').langs

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
  },

  -- nvim-ts-context-commentstring
  context_commentstring = { enable = true },

  -- nvim-treesitter-textobjects
  require'nvim-treesitter.configs'.setup {
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        }
      }
    }
  }
}

-- Automatically install parser for new filetype (with confirmation)
-- From nvim-treesitter issue #2108:
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/2108
-- local ask_install = {}
-- function _G.ensure_treesitter_language_installed()
--   local parsers = require "nvim-treesitter.parsers"
--   local lang = parsers.get_buf_lang()
--   if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) and ask_install[lang] ~= false then
--     vim.schedule_wrap(function()
--       vim.ui.select({"yes", "no"}, { prompt = "Install tree-sitter parsers for " .. lang .. "?" }, function(item)
--         if item == "yes" then
--           vim.cmd("TSInstall " .. lang)
--         elseif item == "no" then
--           ask_install[lang] = false
--         end
--       end)
--     end)()
--   end
-- end

-- Automatically install treesitter parsers (no confirmation)
local parsers = require'nvim-treesitter.parsers'
function _G.ensure_treesitter_language_installed()
  local lang = parsers.get_buf_lang()
  if parsers.get_parser_configs()[lang] and not parsers.has_parser(lang) then
    vim.schedule_wrap(function()
    vim.cmd("TSInstall "..lang)
    end)()
  end
end

vim.cmd [[autocmd FileType * :lua ensure_treesitter_language_installed()]]
