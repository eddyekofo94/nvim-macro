local M = {}

local langs_mt = {}
langs_mt.__index = langs_mt

---@param field string
---@return string[]
function langs_mt:list(field)
  local deduplist = {}
  local result = {}
  -- deduplication
  for _, info in pairs(self) do
    if type(info[field]) == 'string' then
      deduplist[info[field]] = true
    elseif type(info[field]) == 'table' then
      for _, name in pairs(info[field]) do
        deduplist[name] = true
      end
    end
  end
  for name, _ in pairs(deduplist) do
    table.insert(result, name)
  end
  return result
end

---@param field string
---@return table<string, string|string[]>
function langs_mt:map(field)
  local result = {}
  for lang, info in pairs(self) do
    result[lang] = info[field]
  end
  return result
end

M.langs = setmetatable({
  c = { ts = 'c', ft = 'c', dap = 'codelldb' },
  cpp = { ts = 'cpp', ft = 'cpp', dap = 'codelldb' },
  cuda = { ts = 'cuda', ft = 'cuda' },
  fish = { ts = 'fish', ft = 'fish' },
  help = { ts = 'vimdoc', ft = 'help' },
  lua = { ts = 'lua', ft = 'lua' },
  make = { ts = 'make', ft = 'make' },
  markdown = { ts = { 'markdown_inline', 'markdown' } },
  python = { ts = 'python', ft = 'python', dap = 'debugpy' },
  query = { ts = 'query' },
  rust = { ts = 'rust', ft = 'rust' },
  sh = { ft = 'sh', dap = 'bashdb' },
  tex = { ft = 'tex', ts = 'latex' },
  vim = { ts = 'vim', ft = 'vim' },
}, langs_mt)

local icons_mt = {}

function icons_mt:__index(key)
  for _, icons in pairs(self) do
    if icons[key] then
      return icons[key]
    end
  end
  return icons_mt[key]
end

---Flatten the layered icons table into a single type-icon table.
---@return table<string, string>
function icons_mt:flatten()
  local result = {}
  for _, icons in pairs(self) do
    for type, icon in pairs(icons) do
      result[type] = icon
    end
  end
  return result
end

if vim.g.modern_ui then
  M.box = require('utils.static._box')
  M.borders = require('utils.static._borders')
  M.icons = setmetatable(require('utils.static._icons'), icons_mt)
else
  M.box = require('utils.static._box_ascii')
  M.borders = require('utils.static._borders_ascii')
  M.icons = setmetatable(require('utils.static._icons_ascii'), icons_mt)
end

return M
