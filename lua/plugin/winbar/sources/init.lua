---@class winbar_source_t
---@field get_symbols fun(buf: integer, cursor: integer[]): winbar_symbol_t[]

---@type table<string, winbar_source_t>
return {
  lsp = require('plugin.winbar.sources.lsp'),
  markdown = require('plugin.winbar.sources.markdown'),
  path = require('plugin.winbar.sources.path'),
  treesitter = require('plugin.winbar.sources.treesitter'),
}
